//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/13.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private let detailView = DetailView()
    private var disposeBag = DisposeBag()
    private let addCartButton: UIBarButtonItem = {
        let cartImage = UIImage(systemName: "cart.fill")
        let barButtonItem = UIBarButtonItem(image: cartImage,
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        barButtonItem.tintColor = .black
        return barButtonItem
    }()

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
        navigationItem.rightBarButtonItem = addCartButton

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

        let input = DetailViewModel.Input(didShowView: didShowView,
                                          didTapAddCartButton: didTapAddCartButton)
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
                owner.configureAlert()
            })
            .disposed(by: disposeBag)
    }
}

extension DetailViewController {
    func configureAlert() {
        let confirmAction = UIAlertAction(title: "확인",
                                          style: .default)

        let alert = AlertManager.shared
            .setType(.alert)
            .setTitle("장바구니에 등록되었습니다.")
            .setActions([confirmAction])
            .apply()
        self.present(alert, animated: true)
    }
}
