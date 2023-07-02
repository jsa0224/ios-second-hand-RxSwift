//
//  GridCellViewModel.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/26.
//

import Foundation
import RxSwift

final class GridCellViewModel {
    struct Input {
        let didShowCell: Observable<Item>
        let didShowFavoriteButton: Observable<Int>
        let didTapFavoriteButton: Observable<(Int, String, String, String, Double, Double, Double, Int, Bool, Bool)>
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


        return Output(workItem: item,
                      isSelected: isSelected,
                      tappedFavoriteButton: tappedFavoriteButton)
    }

}

