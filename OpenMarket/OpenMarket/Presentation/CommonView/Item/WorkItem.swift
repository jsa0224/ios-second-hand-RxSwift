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
    private let thumbnail: UIImage

    init(item: Item, thumbnail: UIImage) {
        self.item = item
        self.thumbnail = thumbnail
    }

    var itemImage: UIImage {
        return thumbnail
    }

    var name: String {
        return item.name
    }

    var description: String {
        return item.description
    }

    var price: String {
        return item.price.formatDouble + Description.monetaryUnit
    }

    var discountedPrice: String {
        return item.discountedPrice.formatDouble + Description.monetaryUnit
    }

    var bargainPrice: String {
        return item.bargainPrice.formatDouble + Description.monetaryUnit
    }

    var stock: String {
        if isEmpty {
            return Namespace.soldOut
        }
        
        return Namespace.stockCount + item.stock.formatInt
    }

    var isEmpty: Bool {
        return item.stock == Namespace.zero
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
                                   range: NSMakeRange(Namespace.zero, attribute.length))

            return attribute
        }

        return nil
    }

    var isEmptyThumbnail: Bool {
        return thumbnail != nil
    }

    private enum Namespace {
        static let soldOut = "Sold Out"
        static let stockCount = "재고 개수: "
        static let zero = 0
    }
}
