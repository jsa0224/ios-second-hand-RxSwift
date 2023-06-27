//
//  CartViewModel.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/15.
//

import Foundation
import RxSwift

final class CartViewModel {
    struct Input {
        let didShowView: Observable<Void>
        let didTapDeleteButton: Observable<AlertActionType>
        let deletedItem: Observable<Item>
    }

    struct Output {
        var itemList: Observable<[Item]>
        let deleteAlertAction: Observable<AlertActionType>
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
                    .fetch(with: true)
            }

        let deleteAlertAction = input.didTapDeleteButton
            .withUnretained(self)
            .map { owner, action in
                if action == .delete {
                    input.deletedItem
                        .map {
                            owner
                                .itemUseCase
                                .delete($0)
                        }
                }

                return action
            }

        return Output(itemList: itemList,
                      deleteAlertAction: deleteAlertAction)
    }
}
