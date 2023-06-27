//
//  ItemCellViewModel.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/07.
//

import UIKit
import RxSwift

final class TableViewCellViewModel {
    struct Input {
        var didShowCell: Observable<Item>
    }

    struct Output {
        var workItem: Observable<WorkItem>
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

        return Output(workItem: item)
    }
    
}
