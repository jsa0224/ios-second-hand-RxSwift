//
//  PriceView.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/27.
//

import UIKit

final class PriceView: UIView {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Layout.spacing
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Layout.spacing
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private let priceForSaleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Layout.spacing
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private let totalPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Layout.spacing
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private(set) var priceTextLabel: TotalPriceLabel = {
        let label = TotalPriceLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()

    private(set) var priceForSaleTextLabel: TotalPriceLabel = {
        let label = TotalPriceLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()

    private(set) var totalTextLabel: TotalPriceLabel = {
        let label = TotalPriceLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        label.textColor = UIColor(named: Color.selected)
        return label
    }()

    private(set) var priceLabel: TotalPriceLabel = {
        let label = TotalPriceLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.textAlignment = .right
        return label
    }()

    private(set) var priceForSaleLabel: TotalPriceLabel = {
        let label = TotalPriceLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.textAlignment = .right
        return label
    }()

    private(set) var totalPriceLabel: TotalPriceLabel = {
        let label = TotalPriceLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.textColor = UIColor(named: Color.selected)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(priceStackView)
        mainStackView.addArrangedSubview(priceForSaleStackView)
        mainStackView.addArrangedSubview(totalPriceStackView)

        priceStackView.addArrangedSubview(priceTextLabel)
        priceStackView.addArrangedSubview(priceLabel)

        priceForSaleStackView.addArrangedSubview(priceForSaleTextLabel)
        priceForSaleStackView.addArrangedSubview(priceForSaleLabel)

        totalPriceStackView.addArrangedSubview(totalTextLabel)
        totalPriceStackView.addArrangedSubview(totalPriceLabel)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.heightAnchor.constraint(equalTo: widthAnchor,
                                                  multiplier: Layout.multiplier)
        ])
    }

    private enum Layout {
        static let spacing: CGFloat = 4
        static let multiplier: CGFloat = 0.4
    }
}
