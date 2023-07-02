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
        let didShowFavoriteButton: Observable<Int>
        let didTapFavoriteButton: Observable<(Int, String, String, String, Double, Double, Double, Int, Bool, Bool)>
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
                      popDetailViewTrigger: popDetailViewTrigger,
                      isSelected: isSelected,
                      tappedFavoriteButton: tappedFavoriteButton)
    }
}
