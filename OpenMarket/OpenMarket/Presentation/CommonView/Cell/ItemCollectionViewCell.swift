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
        itemView.stockLabel.text = nil
        
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
            .map { $0.discountedPrice }
            .bind(to: itemView.priceForSaleLabel.rx.text)
            .disposed(by: disposeBag)

        output?
            .workItem
            .observe(on: MainScheduler.instance)
            .map { $0.stock }
            .bind(to: itemView.stockLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func configureLayout() {
        contentView.addSubview(itemView)

        NSLayoutConstraint.activate([
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
