//
//  DetailViewModel.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/12.
//

import Foundation
import RxSwift

final class DetailViewModel {
    typealias ItemData = (id: Int,
                      name: String,
                      description: String,
                      thumbnail: String,
                      price: Double,
                      bargainPrice: Double,
                      discountedPrice: Double,
                      stock: Int,
                      favorite: Bool,
                      isAddCart: Bool)

    struct Input {
        let didShowView: Observable<Void>
        let didTapAddCartButton: Observable<ItemData>
        let didShowFavoriteButton: Observable<Int>
        let didTapFavoriteButton: Observable<ItemData>
    }

    struct Output {
        let workItem: Observable<WorkItem>
        let popDetailViewTrigger: Observable<Void>
        let isSelected: Observable<Bool>
        let tappedFavoriteButton: Observable<Void>
    }

    private let itemUseCase: ItemUseCaseType
    private let imageUseCase: ImageUseCaseType
    private(set) var item: Item

    init(itemUseCase: ItemUseCaseType, imageUseCase: ImageUseCaseType, item: Item) {
        self.itemUseCase = itemUseCase
        self.imageUseCase = imageUseCase
        self.item = item
    }

    func transform(_ input: Input) -> Output {
        let workItem = input.didShowView
            .withUnretained(self)
            .flatMap { owner, _ in
                owner
                    .imageUseCase
                    .fetchItemImage(owner.item.thumbnail)
                    .map {
                        WorkItem(item: owner.item, thumbnail: $0)
                    }
            }

        let popDetailViewTrigger = input.didTapAddCartButton
            .withUnretained(self)
            .map { owner, data in
                let dataToSave = Item(id: data.id,
                                      stock: data.stock,
                                      name: data.name,
                                      description: data.description,
                                      thumbnail: data.thumbnail,
                                      price: data.price,
                                      bargainPrice: data.bargainPrice,
                                      discountedPrice: data.discountedPrice,
                                      favorites: data.favorite,
                                      isAddCart: data.isAddCart)
                owner.itemUseCase.save(dataToSave)
            }

        let isSelected = input.didShowFavoriteButton
            .withUnretained(self)
            .flatMap { owner, id in
                owner
                    .itemUseCase
                    .fetch(with: id)
            }
            .map { item in
                guard let item else { return false }
                return item.favorites
            }

        let tappedFavoriteButton = input.didTapFavoriteButton
            .withUnretained(self)
            .map { owner, data in
                let dataToSave = Item(id: data.id,
                                      stock: data.stock,
                                      name: data.name,
                                      description: data.description,
                                      thumbnail: data.thumbnail,
                                      price: data.price,
                                      bargainPrice: data.bargainPrice,
                                      discountedPrice: data.discountedPrice,
                                      favorites: data.favorite,
                                      isAddCart: data.isAddCart)
                owner.itemUseCase.save(dataToSave)
            }

        return Output(workItem: workItem,
                      popDetailViewTrigger: popDetailViewTrigger,
                      isSelected: isSelected,
                      tappedFavoriteButton: tappedFavoriteButton)
    }
}
