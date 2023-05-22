//
//  ItemForm.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

struct ItemForm {
    let name: String
    let description: String
    let price: Int
    let currency: Currency
    let discountedPrice: Int
    let stock: Int
    let secret: String
}

extension ItemForm {
    func toResponseModel() -> ProductForm {
        return ProductForm(name: self.name,
                           description: self.description,
                           price: self.price,
                           currency: self.currency,
                           discountedPrice: self.discountedPrice,
                           stock: self.stock,
                           secret: self.secret)
    }
}
