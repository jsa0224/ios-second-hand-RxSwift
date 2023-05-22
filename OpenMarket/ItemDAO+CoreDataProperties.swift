//
//  ItemDAO+CoreDataProperties.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//
//

import Foundation
import CoreData


extension ItemDAO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemDAO> {
        return NSFetchRequest<ItemDAO>(entityName: "ItemDAO")
    }

    @NSManaged public var id: Int16
    @NSManaged public var stock: Int16
    @NSManaged public var name: String?
    @NSManaged public var explanation: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var price: Double
    @NSManaged public var bargainPrice: Double
    @NSManaged public var discountedPrice: Double
    @NSManaged public var favorites: Bool

}

extension ItemDAO : Identifiable {

}

extension ItemDAO {
    func toDomain() -> Item {
        return Item(id: Int(self.id),
                    stock: Int(self.stock),
                    name: self.name ?? "",
                    description: self.explanation ?? "",
                    thumbnail: self.thumbnail ?? "",
                    price: self.price,
                    bargainPrice: self.bargainPrice,
                    discountedPrice: self.discountedPrice,
                    favorites: self.favorites)
    }
}
