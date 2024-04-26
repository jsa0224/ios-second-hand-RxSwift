//
//  DetailView.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/12.
//

import UIKit
import RxCocoa
import RxSwift

class DetailView: UIView {
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
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.numberOfLines = 2
        return label
    }()

    private(set) var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    private(set) var priceForSaleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    private(set) var favoriteButton: UIButton = {
        let button = UIButton()
        let heartImage = UIImage(systemName: "heart")
        let heartFillImage = UIImage(systemName: "heart.fill")
        button.setImage(heartImage, for: .normal)
        button.setImage(heartFillImage, for: .selected)
        button.tintColor = .systemRed
        button.contentHorizontalAlignment = .right
        return button
    }()

    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 4,
                                                   left: 4,
                                                   bottom: 4,
                                                   right: 4)
        textView.keyboardDismissMode = .onDrag
        textView.setContentHuggingPriority(.init(1),
                                           for: .vertical)
        textView.isEditable = false
        return textView
    }()

    private(set) var cartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add To Cart", for: .normal)
        button.backgroundColor = UIColor(named: "selectedColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
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

    func configureView(_ item: WorkItem) {
        itemImageView.image = item.itemImage
        nameLabel.text = item.name
        stockLabel.text = item.stock
        stockLabel.textColor = item.stockColor
        priceLabel.text = item.price
        priceLabel.textColor = item.priceColor
        priceLabel.attributedText = item.priceAttributeString
        priceLabel.isHidden = item.isHidden
        priceForSaleLabel.text = item.bargainPrice
        descriptionTextView.text = item.description

        if priceLabel.isHidden {
            priceStackView.removeArrangedSubview(priceLabel)
            priceLabel.removeFromSuperview()
        }
    }

    private func configureLayout() {
        addSubview(itemImageView)
        addSubview(textStackView)
        addSubview(cartButton)
        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(middleStackView)
        textStackView.addArrangedSubview(stockLabel)
        textStackView.addArrangedSubview(descriptionTextView)
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
                                               constant: 4),
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
            cartButton.topAnchor.constraint(equalTo: textStackView.bottomAnchor,
                                            constant: 4),
            cartButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: 4),
            cartButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: -4),
            cartButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                               constant: -4)
           ])
    }
}
