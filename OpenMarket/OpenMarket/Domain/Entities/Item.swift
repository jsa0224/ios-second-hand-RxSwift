//
//  Item.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

struct Item {
    let id: Int
    let stock: Int
    let name: String
    let description: String
    let thumbnail: String
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    var favorites: Bool
    var isAddCart: Bool
}
