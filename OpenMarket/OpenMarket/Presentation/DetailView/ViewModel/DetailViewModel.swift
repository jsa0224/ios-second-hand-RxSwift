//
//  DetailViewModel.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/12.
//

import Foundation
import RxSwift

final class DetailViewModel {
    struct Input {
        let didShowView: Observable<Void>
        let didTapAddCartButton: Observable<(Int, String, String, String, Double, Double, Double, Int, Bool, Bool)>
    }

    struct Output {
        let workItem: Observable<WorkItem>
        let popDetailViewTrigger: Observable<Void>
    }

    private let itemUseCase: ItemUseCaseType
    private let item: Item
    private let itemImage: Data

    init(itemUseCase: ItemUseCaseType, item: Item, itemImage: Data) {
        self.itemUseCase = itemUseCase
        self.item = item
        self.itemImage = itemImage
    }

    func transform(_ input: Input) -> Output {
        let workItem = input.didShowView
            .withUnretained(self)
            .map { owner, _ in
                WorkItem(item: owner.item,
                         thumbnail: owner.itemImage)
            }

        let popDetailViewTrigger = input.didTapAddCartButton
            .withUnretained(self)
            .map { owner, data in
                let dataToSave = Item(id: data.0,
                                      stock: data.7,
                                      name: data.1,
                                      description: data.2,
                                      thumbnail: data.3,
                                      price: data.4,
                                      bargainPrice: data.5,
                                      discountedPrice: data.6,
                                      favorites: data.8,
                                      isAddCart: data.9)
                owner.itemUseCase.save(dataToSave)
            }

        return Output(workItem: workItem,
                      popDetailViewTrigger: popDetailViewTrigger)
    }
}
