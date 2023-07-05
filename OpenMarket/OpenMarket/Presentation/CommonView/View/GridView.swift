//
//  ItemView.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/02.
//

import UIKit

final class GridView: UIView {
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
        stackView.distribution = .fill
        return stackView
    }()

    private let middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Layout.spacing
        stackView.distribution = .fill
        return stackView
    }()

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
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
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()

    private(set) var priceForSaleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()

    private(set) var favoriteButton: UIButton = {
        let button = UIButton()
        let heartImage = UIImage(systemName: Image.heart)
        let heartFillImage = UIImage(systemName: Image.heartFill)
        button.setImage(heartFillImage, for: .selected)
        button.setImage(heartImage, for: .normal)
        button.tintColor = .systemPink
        button.contentHorizontalAlignment = .right
        return button
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
        addSubview(itemImageView)
        addSubview(textStackView)
        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(middleStackView)
        middleStackView.addArrangedSubview(priceStackView)
        middleStackView.addArrangedSubview(favoriteButton)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceForSaleLabel)

        if priceLabel.isHidden {
            priceStackView.removeArrangedSubview(priceLabel)
            priceLabel.removeFromSuperview()
        }

        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: topAnchor,
                                               constant: Layout.itemImageViewTopAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: ItemImageViewLayout.leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: ItemImageViewLayout.trailingAnchor),
            itemImageView.heightAnchor.constraint(equalTo: heightAnchor,
                                                  multiplier: ItemImageViewLayout.heightAnchorMultiplier),
            textStackView.topAnchor.constraint(equalTo: itemImageView.bottomAnchor,
                                               constant: TextStackViewLayout.topAnchor),
            textStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: TextStackViewLayout.leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: TextStackViewLayout.trailingAnchor),
            textStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: TextStackViewLayout.bottomAnchor)
           ])
    }

    private enum Layout {
        static let spacing: CGFloat = 4
        static let numberOfLines: Int = 2
        static let itemImageViewTopAnchor: CGFloat = 16
    }

    private enum ItemImageViewLayout {
        static let leadingAnchor: CGFloat = 4
        static let trailingAnchor: CGFloat = -4
        static let heightAnchorMultiplier: CGFloat = 0.65
    }

    private enum TextStackViewLayout {
        static let topAnchor: CGFloat = 4
        static let leadingAnchor: CGFloat = 8
        static let trailingAnchor: CGFloat = -8
        static let bottomAnchor: CGFloat = -4
    }
}
