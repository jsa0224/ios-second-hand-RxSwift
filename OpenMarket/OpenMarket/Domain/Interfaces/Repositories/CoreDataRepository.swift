//
//  CoreDataRepository.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

import Foundation
import RxSwift

protocol CoreDataRepository {
    func save(_ item: Item)
    func fetchItemList() -> Observable<[Item]> 
    func fetchItem(with id: Int) -> Observable<Item>
    func update(_ item: Item)
    func delete(_ item: Item)
}
