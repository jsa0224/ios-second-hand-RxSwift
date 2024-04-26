//
//  ItemDAO+CoreDataProperties.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/12.
//
//

import Foundation
import CoreData


extension ItemDAO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemDAO> {
        return NSFetchRequest<ItemDAO>(entityName: "ItemDAO")
    }

    @NSManaged public var bargainPrice: Double
    @NSManaged public var discountedPrice: Double
    @NSManaged public var explanation: String?
    @NSManaged public var favorites: Bool
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var stock: Int16
    @NSManaged public var thumbnail: String?
    @NSManaged public var isAddCart: Bool

}

extension ItemDAO : Identifiable {

}

extension ItemDAO {
    func toDomain() -> Item {
        return Item(id: Int(self.id),
                    stock: Int(self.stock),
                    name: self.name ?? "",
                    description: self.description,
                    thumbnail: self.thumbnail ?? "",
                    price: self.price,
                    bargainPrice: self.bargainPrice,
                    discountedPrice: self.discountedPrice,
                    favorites: self.favorites,
                    isAddCart: self.isAddCart)
    }
}
