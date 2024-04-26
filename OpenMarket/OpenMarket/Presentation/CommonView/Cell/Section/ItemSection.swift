//
//  ItemSection.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/07.
//

import Foundation
import RxDataSources

struct ItemSection {
    var items: [Item]
}

extension ItemSection: SectionModelType {
    init(original: ItemSection, items: [Item]) {
        self = original
        self.items = items
    }
}

extension ItemSection: Equatable {
    static func == (lhs: ItemSection, rhs: ItemSection) -> Bool {
        return lhs.items == rhs.items
    }
}
