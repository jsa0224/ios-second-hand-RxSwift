//
//  ItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/07.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemCollectionViewCell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }

    private let itemView = ItemView()
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    private var viewModel: ItemCellViewModel?
    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        itemView.itemImageView.image = nil
        itemView.nameLabel.text = nil
        itemView.priceLabel.text = nil
        itemView.priceForSaleLabel.text = nil
        loadingView.startAnimating()
        loadingView.isHidden = false
        
        disposeBag = DisposeBag()
    }

    func bind(_ item: Item) {
        let networkManager = ItemNetworkManager()
        let imageRepository = ItemRepository(networkManager: networkManager)
        let imageUseCase = ImageUseCase(imageRepository: imageRepository)
        viewModel = ItemCellViewModel(imageUseCase: imageUseCase)

        let item: Observable<Item> = Observable.just(item)
        let input = ItemCellViewModel.Input(didShowCell: item)
        let output = viewModel?.transform(input)

        output?
            .workItem
            .observe(on: MainScheduler.instance)
            .map {
                UIImage(data: $0.itemImage) ?? UIImage()
            }
            .bind(to: itemView.itemImageView.rx.image)
            .disposed(by: disposeBag)

        output?
            .workItem
            .observe(on: MainScheduler.instance)
            .map { $0.name }
            .bind(to: itemView.nameLabel.rx.text)
            .disposed(by: disposeBag)

        output?
            .workItem
            .observe(on: MainScheduler.instance)
            .map { $0.price }
            .bind(to: itemView.priceLabel.rx.text)
            .disposed(by: disposeBag)

        output?
            .workItem
            .observe(on: MainScheduler.instance)
            .map { $0.bargainPrice }
            .bind(to: itemView.priceForSaleLabel.rx.text)
            .disposed(by: disposeBag)

        output?
            .workItem
            .observe(on: MainScheduler.instance)
            .map { $0.priceColor }
            .bind(to: itemView.priceLabel.rx.textColor)
            .disposed(by: disposeBag)

        output?
            .workItem
            .observe(on: MainScheduler.instance)
            .map { $0.isHidden }
            .bind(to: itemView.priceLabel.rx.isHidden)
            .disposed(by: disposeBag)

        output?
            .workItem
            .observe(on: MainScheduler.instance)
            .map { $0.priceAttributeString }
            .bind(to: itemView.priceLabel.rx.attributedText)
            .disposed(by: disposeBag)

        output?
            .workItem
            .observe(on: MainScheduler.instance)
            .map { $0.isEmptyThumbnail }
            .bind(to: loadingView.rx.isHidden)
            .disposed(by: disposeBag)

        if loadingView.isHidden {
            loadingView.stopAnimating()
        }
    }

    private func configureLayout() {
        contentView.addSubview(loadingView)
        contentView.addSubview(itemView)

        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            itemView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        contentView.systemLayoutSizeFitting(.init(width: self.bounds.width, height: self.bounds.height))
    }
}
