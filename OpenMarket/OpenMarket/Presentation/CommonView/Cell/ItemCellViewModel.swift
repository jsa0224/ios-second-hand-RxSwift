//
//  ItemCellViewModel.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/07.
//

import UIKit
import RxSwift

final class ItemCellViewModel {
    struct Input {
        var didShowCell: Observable<Item>
    }

    struct Output {
        var workItem: Observable<WorkItem>
    }

    private let imageUseCase: ImageUseCaseType

    init(imageUseCase: ImageUseCaseType) {
        self.imageUseCase = imageUseCase
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
