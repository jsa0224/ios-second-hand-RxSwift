//
//  Item.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

struct Item: Codable, Hashable {
    let id, vendorID, stock: Int
    let name, description, thumbnail, createdAt, issuedAt: String
    let vendorName: String?
    let currency: Currency
    let price, bargainPrice, discountedPrice: Double

    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, currency, price, vendorName, description, stock
        case vendorID = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
