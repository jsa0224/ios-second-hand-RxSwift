//
//  ProductForm.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

struct ProductForm: Codable {
    let name, description: String
    let price: Int
    let currency: String
    let discountedPrice, stock: Int
    let secret: String

    enum CodingKeys: String, CodingKey {
        case name, description
        case price, currency
        case discountedPrice = "discounted_price"
        case stock, secret
    }
}

