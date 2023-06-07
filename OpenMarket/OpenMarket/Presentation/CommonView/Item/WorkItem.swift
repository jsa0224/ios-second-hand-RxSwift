//
//  WorkItem.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/07.
//

import UIKit
import RxSwift

struct WorkItem {
    private let item: Item
    private let thumbnail: Data

    init(item: Item, thumbnail: Data) {
        self.item = item
        self.thumbnail = thumbnail
    }

    var itemImage: Data {
        return thumbnail
    }

    var name: String {
        return item.name
    }

    var price: String {
        return "\(item.price)"
    }

    var discountedPrice: String {
        return "\(item.discountedPrice)"
    }

    var bargainPrice: String {
        return "\(item.bargainPrice)"
    }

    var stock: String {
        if isEmpty {
            return "Sold Out"
        }
        
        return "\(item.stock)"
    }

    var isEmpty: Bool {
        return item.stock == 0
    }

    var isDiscounted: Bool {
        return item.bargainPrice != item.price
    }
}
