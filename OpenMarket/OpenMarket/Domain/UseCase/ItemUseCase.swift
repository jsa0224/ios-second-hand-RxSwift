//
//  ItemUseCase.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/26.
//

import Foundation
import RxSwift

final class ItemUseCase: ItemUseCaseType {
    private let itemRepository: CoreDataRepository

    init(itemRepository: CoreDataRepository) {
        self.itemRepository = itemRepository
    }

    func save(_ item: Item) {
        itemRepository.save(item)
    }

    func fetch() -> Observable<[Item]> {
        return itemRepository.fetchItemList()
    }

    func fetch(with id: Int) -> Observable<Item?> {
        return itemRepository.fetchItem(with: id)
    }

    func fetch(with isAddCart: Bool) -> Observable<[Item]> {
        return itemRepository.fetchItem(with: isAddCart)
    }

    func fetch(by favorites: Bool) -> Observable<[Item]> {
        return itemRepository.fetchItem(by: true)
    }

    func update(_ item: Item) {
        itemRepository.update(item)
    }

    func delete(_ item: Item) {
        itemRepository.delete(item)
    }
}
