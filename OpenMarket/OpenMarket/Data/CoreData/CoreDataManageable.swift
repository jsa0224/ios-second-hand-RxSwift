//
//  CoreDataManageable.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

import CoreData
import RxSwift

protocol CoreDataManageable {
    func create(with item: Item)
    func fetchAllEntities() -> Observable<[ItemDAO]>
    func fetch(with id: Int) -> Observable<ItemDAO>
    func fetch(to isAddCart: Bool) -> Observable<[ItemDAO]>
    func update(with item: Item)
    func delete(with item: Item)
}
