//
//  ListView.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/15.
//

import UIKit

final class ListView: UIView {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = MainStackViewLayout.spacing
        stackView.distribution = .fill
        return stackView
    }()

    private(set) var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let textStackView: UIStackView = {
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
        stackView.axis = .vertical
        stackView.spacing = Layout.spacing
        stackView.distribution = .fill
        return stackView
    }()

    private(set) var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = Layout.numberOfLines
        return label
    }()

    private(set) var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()

    private(set) var priceForSaleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()

    private(set) var stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
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
        mainStackView.addArrangedSubview(itemImageView)
        mainStackView.addArrangedSubview(textStackView)

        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(priceStackView)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceForSaleLabel)
        priceStackView.addArrangedSubview(stockLabel)

        if priceLabel.isHidden {
            priceStackView.removeArrangedSubview(priceLabel)
            priceLabel.removeFromSuperview()
        }

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor,
                                               constant: MainStackViewLayout.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: MainStackViewLayout.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: MainStackViewLayout.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: MainStackViewLayout.bottomAnchor),
            itemImageView.widthAnchor.constraint(equalTo: heightAnchor)
           ])
    }

    private enum Layout {
        static let spacing: CGFloat = 4
        static let numberOfLines: Int = 2
    }

    private enum MainStackViewLayout {
        static let spacing: CGFloat = 8
        static let topAnchor: CGFloat = 8
        static let leadingAnchor: CGFloat = 4
        static let trailingAnchor: CGFloat = -8
        static let bottomAnchor: CGFloat = -8
    }
}
