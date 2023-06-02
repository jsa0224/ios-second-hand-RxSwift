//
//  ItemListUseCase.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/26.
//

import Foundation
import RxSwift

final class ItemListUseCase: ItemListUseCaseType {
    private let itemListRepository: NetworkRepository

    init(itemListRepository: NetworkRepository) {
        self.itemListRepository = itemListRepository
    }

    func fetchItemList(_ pageNo: Int, _ itemPerPage: Int) -> Observable<[Item]> {
        return itemListRepository.fetchItemList(pageNo: pageNo, itemPerPage: itemPerPage)
    }
}
