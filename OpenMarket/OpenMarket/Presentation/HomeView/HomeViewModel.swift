//
//  HomeViewModel.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/02.
//

import Foundation
import RxSwift

final class HomeViewModel {
    struct Input {
        var didShowView: Observable<Void>
    }

    struct Output {
        var itemList: Observable<[Item]>
    }

    private let itemListUseCase: ItemListUseCaseType
    private let imageUseCase: ImageUseCaseType

    init(itemListUseCase: ItemListUseCaseType, imageUseCase: ImageUseCaseType) {
        self.itemListUseCase = itemListUseCase
        self.imageUseCase = imageUseCase
    }

    func transform(_ input: Input) -> Output {
        let itemList = input.didShowView
            .withUnretained(self)
            .flatMap { owner, _   in
                owner
                    .itemListUseCase
                    .fetchItemList(1, 100)
            }

        return Output(itemList: itemList)
    }
}
