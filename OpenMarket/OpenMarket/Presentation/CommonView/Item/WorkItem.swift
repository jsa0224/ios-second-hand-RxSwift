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
        return "\(item.price)원"
    }

    var discountedPrice: String {
        return "\(item.discountedPrice)원"
    }

    var bargainPrice: String {
        return "\(item.bargainPrice)원"
    }

    var stock: String {
        if isEmpty {
            return "Sold Out"
        }
        
        return "재고 개수: \(item.stock)"
    }

    var isEmpty: Bool {
        return item.stock == 0
    }

    var stockColor: UIColor {
        if isEmpty {
            return .systemYellow
        }

        return .systemGray
    }

    var isHidden: Bool {
        return !isDiscounted
    }

    var isDiscounted: Bool {
        return item.bargainPrice != item.price
    }

    var priceColor: UIColor {
        if isDiscounted {
            return .systemRed
        }

        return .systemGray
    }

    var priceAttributeString: NSAttributedString? {
        if isDiscounted {
            let attribute = NSMutableAttributedString(string: price)

            attribute.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                   value: NSUnderlineStyle.single.rawValue,
                                   range: NSMakeRange(0, attribute.length))

            return attribute
        }

        return nil
    }
}
