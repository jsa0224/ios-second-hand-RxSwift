//
//  TotalPriceLabel.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/27.
//

import UIKit

final class TotalPriceLabel: UILabel {
    private var padding = UIEdgeInsets(top: TextContainerInsetLayout.top,
                                       left: TextContainerInsetLayout.left,
                                       bottom: TextContainerInsetLayout.bottom,
                                       right: TextContainerInsetLayout.right)

    convenience init(padding: UIEdgeInsets = UIEdgeInsets(top: .zero,
                                                          left: TextContainerInsetLayout.left,
                                                          bottom: .zero,
                                                          right: TextContainerInsetLayout.right)) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }

    private enum TextContainerInsetLayout {
        static let top: CGFloat = 8
        static let left: CGFloat = 8
        static let right: CGFloat = 8
        static let bottom: CGFloat = 8
    }
}
