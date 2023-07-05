//
//  ItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/07.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemGridCollectionViewCell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }

    private(set) var itemView = GridView()
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    private var viewModel: GridCellViewModel?
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
        let heartImage = UIImage(systemName: "heart")
        itemView.favoriteButton.setImage(heartImage, for: .normal)
        loadingView.startAnimating()
        loadingView.isHidden = false
        
        disposeBag = DisposeBag()
    }

    func bind(_ item: Item) {
        let networkManager = ItemNetworkManager()
        let coreDataManager = CoreDataManager.shared
        let itemRepository = ItemRepository(networkManager: networkManager)
        let itemDetailRepository = ItemDetailRepository(coreDataManager: coreDataManager)
        let itemUseCase = ItemUseCase(itemRepository: itemDetailRepository)
        let imageUseCase = ImageUseCase(imageRepository: itemRepository)
        viewModel = GridCellViewModel(imageUseCase: imageUseCase,
                                      itemUseCase: itemUseCase)

        let didShowCell: Observable<Item> = Observable.just(item)
        let didShowFavoriteButton = Observable.just(item.id)
        let didTapFavoriteButton = itemView.favoriteButton.rx.tap
            .withUnretained(self)
            .flatMap { owner, _ in
                return didShowCell.map { item in
                    return (item.id,
                            item.name,
                            item.description,
                            item.thumbnail,
                            item.price,
                            item.bargainPrice,
                            item.discountedPrice,
                            item.stock,
                            true,
                            item.isAddCart)
                }
            }
        let input = GridCellViewModel.Input(didShowCell: didShowCell,
                                            didShowFavoriteButton: didShowFavoriteButton,
                                            didTapFavoriteButton: didTapFavoriteButton)
        let output = viewModel?.transform(input)

        output?
            .workItem
            .observe(on: MainScheduler.instance)
            .map {
                $0.itemImage
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

        output?
            .isSelected
            .observe(on: MainScheduler.instance)
            .bind(to: itemView.favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)

        output?
            .tappedFavoriteButton
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, bool in
                owner.itemView.favoriteButton.isSelected = true
            })
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
