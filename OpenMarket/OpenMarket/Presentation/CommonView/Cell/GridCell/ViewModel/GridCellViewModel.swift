//
//  GridCellViewModel.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/26.
//

import Foundation
import RxSwift

final class GridCellViewModel {
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
        let didShowCell: Observable<Item>
        let didShowFavoriteButton: Observable<Int>
        let didTapFavoriteButton: Observable<ItemData>
    }

    struct Output {
        let workItem: Observable<WorkItem>
        let isSelected: Observable<Bool>
        let tappedFavoriteButton: Observable<Void>
    }

    private let imageUseCase: ImageUseCaseType
    private let itemUseCase: ItemUseCaseType

    init(imageUseCase: ImageUseCaseType, itemUseCase: ItemUseCaseType) {
        self.imageUseCase = imageUseCase
        self.itemUseCase = itemUseCase
    }

    func transform(_ input: Input) -> Output {
        let item = input.didShowCell
            .withUnretained(self)
            .flatMap { owner, item in
                return owner
                    .imageUseCase
                    .fetchItemImage(item.thumbnail)
                    .map {
                        WorkItem(item: item,
                                 thumbnail: $0)
                         }
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


        return Output(workItem: item,
                      isSelected: isSelected,
                      tappedFavoriteButton: tappedFavoriteButton)
    }

}

