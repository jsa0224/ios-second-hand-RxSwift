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
        stackView.spacing = 8
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
        stackView.spacing = 4
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
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

    private(set) var trashButton: UIButton = {
        let button = UIButton()
        let heartImage = UIImage(systemName: "trash")
        button.setImage(heartImage, for: .normal)
        button.tintColor = .systemGray3
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
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(itemImageView)
        mainStackView.addArrangedSubview(textStackView)
        mainStackView.addArrangedSubview(trashButton)

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
                                               constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: 4),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -8),
            itemImageView.widthAnchor.constraint(equalTo: heightAnchor)
           ])
    }
}
