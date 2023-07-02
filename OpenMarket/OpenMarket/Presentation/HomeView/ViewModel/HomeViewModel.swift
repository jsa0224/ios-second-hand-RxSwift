//
//  HomeViewModel.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/02.
//

import Foundation
import RxSwift
import RxRelay

final class HomeViewModel {
    struct Input {
        var didShowView: Observable<Void>
        var didScrollBottom: Observable<Int?>
    }

    struct Output {
        var itemList: Observable<[Item]>
    }

    private let itemListUseCase: ItemListUseCaseType
    private var itemSubject = BehaviorRelay<[Item]>(value: [])
    private var pageNo = 1
    private let itemPerPage = 10

    init(itemListUseCase: ItemListUseCaseType) {
        self.itemListUseCase = itemListUseCase
    }

    func transform(_ input: Input, _ disposeBag: DisposeBag) -> Output {
        var itemList: Observable<[Item]> {
            return itemSubject.asObservable()
        }

        let _ = input.didShowView
            .withUnretained(self)
            .flatMapLatest({ owner, _ in
                return owner.itemListUseCase.fetchItemList(owner.pageNo,
                                                           owner.itemPerPage)
            })
            .bind(to: itemSubject)

        let _ = input.didScrollBottom
            .filter { $0 == self.pageNo * 10 - 1}
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.pageNo += 1
                owner.itemListUseCase.fetchItemList(owner.pageNo, owner.itemPerPage)
                    .subscribe(onNext: { item in
                        let preItem = owner.itemSubject.value
                        owner.itemSubject.accept(preItem + item)
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)

        return Output(itemList: itemList)
    }
}
