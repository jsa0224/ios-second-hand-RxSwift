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
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()

    private let middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()

    private(set) var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
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

    private(set) var heartButton: UIButton = {
        let button = UIButton()
        let heartImage = UIImage(systemName: "heart")
        let heartFillImage = UIImage(systemName: "heart.fill")
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
        middleStackView.addArrangedSubview(heartButton)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceForSaleLabel)

        if priceLabel.isHidden {
            priceStackView.removeArrangedSubview(priceLabel)
            priceLabel.removeFromSuperview()
        }

        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: topAnchor,
                                               constant: 16),
            itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: 4),
            itemImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -4),
            itemImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            textStackView.topAnchor.constraint(equalTo: itemImageView.bottomAnchor,
                                               constant: 4),
            textStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: -8),
            textStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -4)
           ])
    }
}
