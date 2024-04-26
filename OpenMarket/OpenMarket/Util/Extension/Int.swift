//
//  Int.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/07/02.
//

import Foundation

extension Int {
    var formatInt: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        guard let string = formatter.string(for: self) else {
            return ""
        }

        return string
    }
}
