//
//  FavoriteViewModel.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/30.
//

import Foundation
import RxSwift

final class FavoriteViewModel {
    struct Input {
        let didShowView: Observable<Void>
        let didTapDeleteButton: Observable<(AlertActionType, Item)>
        let deletedAlertAction: Observable<IndexPath>
    }

    struct Output {
        var itemList: Observable<[Item]>
        let deleteAlertAction: Observable<(AlertActionType, IndexPath)>
    }

    private let itemUseCase: ItemUseCaseType

    init(itemUseCase: ItemUseCaseType) {
        self.itemUseCase = itemUseCase
    }

    func transform(_ input: Input) -> Output {
        let itemList = input.didShowView
            .withUnretained(self)
            .flatMap { owner, _ in
                owner
                    .itemUseCase
                    .fetch(by: true)
            }

        let deleteAlertActionType = input.didTapDeleteButton
            .withUnretained(self)
            .map { owner, input in
                if input.0 == .delete {
                    owner
                        .itemUseCase
                        .delete(input.1)
                }

                return input.0
            }

        let indexPath = input.deletedAlertAction
            .withUnretained(self)
            .map { owner, indexPath in
                return indexPath
            }

        let deleteAlertAction = Observable.zip(deleteAlertActionType, indexPath)

        return Output(itemList: itemList,
                      deleteAlertAction: deleteAlertAction)
    }
}

