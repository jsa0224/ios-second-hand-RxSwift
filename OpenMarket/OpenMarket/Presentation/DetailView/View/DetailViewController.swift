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
    private let detailView = DetailView()
    private var disposeBag = DisposeBag()

    init(viewModel: DetailViewModel, disposeBag: DisposeBag = DisposeBag()) {
        self.viewModel = viewModel
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
                                            constant: 8),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: 8),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -8),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -8)
        ])
    }

    private func bind() {
        let didShowView = self.rx.viewWillAppear.asObservable()
        let didTapAddCartButton = detailView.cartButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                return (owner.viewModel.item.id,
                        owner.viewModel.item.name,
                        owner.viewModel.item.description,
                        owner.viewModel.item.thumbnail,
                        owner.viewModel.item.price,
                        owner.viewModel.item.bargainPrice,
                        owner.viewModel.item.discountedPrice,
                        owner.viewModel.item.stock,
                        owner.viewModel.item.favorites,
                        true)
            }

        let didShowFavoriteButton = Observable.just(viewModel.item.id)

        let didTapFavoriteButton = detailView.heartButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                return (owner.viewModel.item.id,
                        owner.viewModel.item.name,
                        owner.viewModel.item.description,
                        owner.viewModel.item.thumbnail,
                        owner.viewModel.item.price,
                        owner.viewModel.item.bargainPrice,
                        owner.viewModel.item.discountedPrice,
                        owner.viewModel.item.stock,
                        true,
                        owner.viewModel.item.isAddCart)
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
                owner.configureAlert(message: "장바구니")
                owner.tabBarController?.selectedIndex = 2
            })
            .disposed(by: disposeBag)

        output
            .isSelected
            .observe(on: MainScheduler.instance)
            .bind(to: detailView.heartButton.rx.isSelected)
            .disposed(by: disposeBag)

        output
            .tappedFavoriteButton
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, bool in
                owner.detailView.heartButton.isSelected = true
                owner.configureAlert(message: "관심상품")
                owner.tabBarController?.selectedIndex = 1
            })
            .disposed(by: disposeBag)
    }
}

extension DetailViewController {
    func configureAlert(message: String) {
        let confirmAction = UIAlertAction(title: "확인",
                                          style: .default)

        let alert = AlertManager.shared
            .setType(.alert)
            .setTitle(message + "에 등록되었습니다.")
            .setActions([confirmAction])
            .apply()
        self.present(alert, animated: true)
    }
}
