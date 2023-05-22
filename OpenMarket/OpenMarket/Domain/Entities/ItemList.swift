//
//  ItemList.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

struct ItemList: Codable {
    let pageNo, itemsPerPage, totalCount, offset, limit, lastPage: Int
    let hasNext, hasPrev: Bool
    let pages: [Item]
}
