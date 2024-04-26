//
//  Product.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

struct Product: Codable, Hashable {
    let id, vendorID, stock: Int
    let vendorName, name, description: String
    let thumbnail: String
    let currency: String
    let price, bargainPrice, discountedPrice: Double
    let createdAt, issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case vendorName, name, description, thumbnail, currency, price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

extension Product {
    func toDomain() -> Item {
        return Item(id: self.id,
                    stock: self.stock,
                    name: self.name,
                    description: self.description,
                    thumbnail: self.thumbnail,
                    price: self.price,
                    bargainPrice: self.bargainPrice,
                    discountedPrice: self.discountedPrice,
                    favorites: false,
                    isAddCart: false)
    }
}
