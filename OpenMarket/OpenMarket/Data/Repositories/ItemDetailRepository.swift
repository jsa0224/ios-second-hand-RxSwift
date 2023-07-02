//
//  ItemDetailRepository.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

import RxSwift

final class ItemDetailRepository: CoreDataRepository {
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func save(_ item: Item) {
        coreDataManager.create(with: item)
    }

    func fetchItemList() -> Observable<[Item]> {
        return coreDataManager.fetchAllEntities()
            .map {
                $0.map { $0.toDomain() }
            }
    }

    func fetchItem(with id: Int) -> Observable<Item?> {
        return coreDataManager.fetch(with: id)
            .map { $0?.toDomain() }
    }

    func fetchItem(with isAddCart: Bool) -> Observable<[Item]> {
        return coreDataManager.fetch(to: isAddCart)
            .map {
                $0.map { $0.toDomain() }
            }
    }

    func fetchItem(by favorites: Bool) -> Observable<[Item]> {
        return coreDataManager.fetch(with: favorites)
            .map {
                $0.map { $0.toDomain() }
            }
    }

    func update(_ item: Item) {
        coreDataManager.update(with: item)
    }

    func delete(_ item: Item) {
        coreDataManager.delete(with: item)
    }
}
