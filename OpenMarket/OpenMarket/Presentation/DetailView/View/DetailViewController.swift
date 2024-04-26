//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/13.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private let coordinator: DetailCoordinator
    private let detailView = DetailView()
    private var disposeBag = DisposeBag()

    init(viewModel: DetailViewModel,
         coordinator: DetailCoordinator,
         disposeBag: DisposeBag = DisposeBag()) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.disposeBag = disposeBag
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(detailView)

        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: DetailViewLayout.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: DetailViewLayout.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: DetailViewLayout.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: DetailViewLayout.bottomAnchor)
        ])
    }

    private func bind() {
        let didShowView = self.rx.viewWillAppear.asObservable()
        let didTapAddCartButton = detailView.cartButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                return (id: owner.viewModel.item.id,
                        name: owner.viewModel.item.name,
                        description: owner.viewModel.item.description,
                        thumbnail: owner.viewModel.item.thumbnail,
                        price: owner.viewModel.item.price,
                        bargainPrice: owner.viewModel.item.bargainPrice,
                        discountedPrice: owner.viewModel.item.discountedPrice,
                        stock: owner.viewModel.item.stock,
                        favorite: owner.viewModel.item.favorites,
                        isAddCart: true)
            }

        let didShowFavoriteButton = Observable.just(viewModel.item.id)

        let didTapFavoriteButton = detailView.favoriteButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                return (id: owner.viewModel.item.id,
                        name: owner.viewModel.item.name,
                        description: owner.viewModel.item.description,
                        thumbnail: owner.viewModel.item.thumbnail,
                        price: owner.viewModel.item.price,
                        bargainPrice: owner.viewModel.item.bargainPrice,
                        discountedPrice: owner.viewModel.item.discountedPrice,
                        stock: owner.viewModel.item.stock,
                        favorite: true,
                        isAddCart: owner.viewModel.item.isAddCart)
            }

        let input = DetailViewModel.Input(didShowView: didShowView,
                                          didTapAddCartButton: didTapAddCartButton,
                                          didShowFavoriteButton: didShowFavoriteButton,
                                          didTapFavoriteButton: didTapFavoriteButton)
        let output = viewModel.transform(input)

        output
            .workItem
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, item in
                owner.detailView.configureView(item)
            })
            .disposed(by: disposeBag)

        output
            .popDetailViewTrigger
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.coordinator.configureAlert(message: Text.cartItem)
                owner.coordinator.moveToCartView(by: owner)
            })
            .disposed(by: disposeBag)

        output
            .isSelected
            .observe(on: MainScheduler.instance)
            .bind(to: detailView.favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)

        output
            .tappedFavoriteButton
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.detailView.favoriteButton.isSelected = true
                owner.coordinator.configureAlert(message: Text.favoriteItem)
                owner.coordinator.moveToFavoriteView(by: owner)
            })
            .disposed(by: disposeBag)
    }

    private enum DetailViewLayout {
        static let topAnchor: CGFloat = 8
        static let leadingAnchor: CGFloat = 8
        static let trailingAnchor: CGFloat = -8
        static let bottomAnchor: CGFloat = -8
    }

    private enum Text {
        static let cartItem = "장바구니"
        static let favoriteItem = "관심상품"
    }
}
