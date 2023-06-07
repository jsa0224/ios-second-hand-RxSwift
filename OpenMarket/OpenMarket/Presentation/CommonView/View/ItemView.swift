//
//  ItemView.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/02.
//

import UIKit

final class ItemView: UIView {
    private(set) var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
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
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()

    private(set) var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private(set) var priceLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()

    private(set) var priceForSaleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private(set) var stockLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let heartButton: UIButton = {
        let button = UIButton()
        let heartImage = UIImage(systemName: "heart")
        let heartFillImage = UIImage(systemName: "heart.fill")
        button.setImage(heartImage, for: .normal)
        button.setImage(heartFillImage, for: .selected)
        button.tintColor = .systemRed
        return button
    }()

    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        addSubview(itemImageView)
        addSubview(textStackView)
        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(middleStackView)
        middleStackView.addArrangedSubview(priceStackView)
        middleStackView.addArrangedSubview(heartButton)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceForSaleLabel)
        textStackView.addArrangedSubview(stockLabel)

        NSLayoutConstraint.activate([
            itemImageView.widthAnchor.constraint(equalTo: widthAnchor),
            itemImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            textStackView.topAnchor.constraint(equalTo: itemImageView.bottomAnchor),
            textStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
           ])
    }

    func configureView(item: WorkItem, image: UIImage) {
        nameLabel.text = item.name
        priceLabel.text = .none
        priceLabel.attributedText = .none
        stockLabel.text = Namespace.stock + item.stock
        stockLabel.textColor = .systemGray
        priceForSaleLabel.text = item.discountedPrice
        priceForSaleLabel.textColor = .systemGray

        if item.isDiscounted {
            priceLabel.isHidden = false
            priceForSaleLabel.text = item.discountedPrice
            priceLabel.textColor = .systemRed
            priceLabel.text = item.price

            guard let priceText = priceLabel.text else { return }
            let attribute = NSMutableAttributedString(string: priceText)
            attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attribute.length))
            priceLabel.attributedText = attribute
            priceForSaleLabel.textColor = .systemGray
        }

        if item.isEmpty {
            stockLabel.textColor = .systemYellow
        }

        layer.cornerRadius = 10.0
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
    }

    private enum Namespace {
        static let stock = "잔여수량: "
        static let soldOut = "품절"
        static let textViewPlaceHolder = "텍스트를 입력하세요."
    }

}
