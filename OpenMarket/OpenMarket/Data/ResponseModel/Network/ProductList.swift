//
//  ProductList.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

struct ProductList: Codable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [Product]
}

extension ProductList {
    func toDomain() -> ItemList {
        return ItemList(pageNo: self.pageNo,
                        itemsPerPage: self.itemsPerPage,
                        totalCount: self.totalCount,
                        offset: self.offset,
                        limit: self.limit,
                        lastPage: self.lastPage,
                        hasNext: self.hasNext,
                        hasPrev: self.hasPrev,
                        pages: self.pages.map { $0.toDomain() })
    }
}
