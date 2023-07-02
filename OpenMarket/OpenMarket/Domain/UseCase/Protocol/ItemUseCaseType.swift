//
//  ItemUseCaseType.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/28.
//

import Foundation
import RxSwift

protocol ItemUseCaseType {
    func save(_ item: Item)
    func fetch() -> Observable<[Item]>
    func fetch(with id: Int) -> Observable<Item?>
    func fetch(with isAddCart: Bool) -> Observable<[Item]>
    func fetch(by favorites: Bool) -> Observable<[Item]>
    func update(_ item: Item)
    func delete(_ item: Item)
}
