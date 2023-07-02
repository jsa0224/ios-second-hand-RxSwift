//
//  SearchViewModel.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/07/02.
//

import Foundation
import RxSwift
import RxRelay

final class SearchViewModel {
    struct Input {
        let didEndSearching: Observable<String>
    }

    struct Output {
        let itemList: Observable<[Item]>
    }

    private let itemListUseCase: ItemListUseCaseType

    init(itemListUseCase: ItemListUseCaseType) {
        self.itemListUseCase = itemListUseCase
    }

    func transform(_ input: Input, _ disposeBag: DisposeBag) -> Output {
        let itemList = input.didEndSearching
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .flatMap { owner, name in
                owner
                    .itemListUseCase
                    .fetchItem(by: name)
            }

        return Output(itemList: itemList)
    }
}

