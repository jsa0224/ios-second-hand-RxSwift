//
//  ItemList.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

struct ItemList {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [Item]
}
