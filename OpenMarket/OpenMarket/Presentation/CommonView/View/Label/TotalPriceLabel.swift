//
//  TotalPriceLabel.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/27.
//

import UIKit

final class TotalPriceLabel: UILabel {
    private var padding = UIEdgeInsets(top: Layout.textContainerInsetTop,
                                       left: Layout.textContainerInsetLeft,
                                       bottom: Layout.textContainerInsetBottom,
                                       right: Layout.textContainerInsetRight)

    convenience init(padding: UIEdgeInsets = UIEdgeInsets(top: .zero,
                                                          left: Layout.textContainerInsetLeft,
                                                          bottom: .zero,
                                                          right: Layout.textContainerInsetRight)) {
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

    private enum Layout {
        static let textContainerInsetTop: CGFloat = 8
        static let textContainerInsetLeft: CGFloat = 8
        static let textContainerInsetRight: CGFloat = 8
        static let textContainerInsetBottom: CGFloat = 8
    }
}
