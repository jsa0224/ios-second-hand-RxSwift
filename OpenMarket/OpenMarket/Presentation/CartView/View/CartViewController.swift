//
//  CartViewController.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class CartViewController: UIViewController {
    typealias DataSource = RxTableViewSectionedReloadDataSource<ItemSection>

    private let viewModel: CartViewModel
    private var disposeBag = DisposeBag()
    private var tableView = UITableView()
    private var itemListDataSource = DataSource { _, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier,
                                                       for: indexPath) as? ItemTableViewCell else {
            return ItemTableViewCell()
        }

        cell.bind(item)

        return cell
    }
    private var tableViewItemSubject = BehaviorSubject<[ItemSection]>(value: [])
    private let priceView = PriceView()

    init(viewModel: CartViewModel, disposeBag: DisposeBag = DisposeBag()) {
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
        let image = UIImage(named: "SecondHand")
        navigationItem.titleView = UIImageView(image: image)
        navigationItem.titleView?.contentMode = .scaleAspectFit
        self.view.backgroundColor = .white

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ItemTableViewCell.self,
                           forCellReuseIdentifier: ItemTableViewCell.identifier)
        self.view.addSubview(tableView)
        self.view.addSubview(priceView)

        priceView.priceTextLabel.text = "Price:"
        priceView.priceForSaleTextLabel.text = "Discounted Price:"
        priceView.totalTextLabel.text = "Total Price:"

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            priceView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            priceView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            priceView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            priceView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func bind() {
        let didShowView = self.rx.viewWillAppear.asObservable()
        let deleteAction = tableView.rx.itemDeleted
            .withUnretained(self)
            .flatMap { owner, indexPath in
               self.showDeleteAlert()
            }
        let deletedItem = tableView.rx.itemDeleted
            .withUnretained(self)
            .map { owner, indexPath in
                var sectionArray = owner.itemListDataSource.sectionModels
                var section = sectionArray[indexPath.section]
                let item = section.items.remove(at: indexPath.row)
                sectionArray[indexPath.section] = section
                return item
            }
        let deleteAndDeletedItem = Observable.zip(deleteAction, deletedItem)
        let deletedAlertAction = tableView.rx.itemDeleted
            .withUnretained(self)
            .map { owner, indexPath in
               return indexPath
            }

        let input = CartViewModel.Input(didShowView: didShowView,
                                        didTapDeleteButton: deleteAndDeletedItem,
                                        deletedAlertAction: deletedAlertAction)
        let output = viewModel.transform(input)

        output
            .itemList
            .withUnretained(self)
            .map { owner, item in
                [ItemSection(items: item)]
            }
            .bind(to: tableViewItemSubject)
            .disposed(by: disposeBag)

        tableViewItemSubject
            .distinctUntilChanged()
            .bind(to: self.tableView.rx.items(dataSource: itemListDataSource))
            .disposed(by: self.disposeBag)

        output.itemList
            .withUnretained(self)
            .map { owner, item in
                item.compactMap {
                    $0.price
                }
                .reduce(0.0, +)
            }
            .map { price in
                price.formatDouble + "원"
            }
            .bind(to: priceView.priceLabel.rx.text)
            .disposed(by: disposeBag)

        output.itemList
            .withUnretained(self)
            .map { owner, item in
                item.compactMap {
                    $0.discountedPrice
                }
                .reduce(0.0, +)
            }
            .map { price in
                "-" + price.formatDouble + "원"
            }
            .bind(to: priceView.priceForSaleLabel.rx.text)
            .disposed(by: disposeBag)

        output.itemList
            .withUnretained(self)
            .map { owner, item in
                item.compactMap {
                    $0.bargainPrice
                }
                .reduce(0.0, +)
            }
            .map { price in
                price.formatDouble + "원"
            }
            .bind(to: priceView.totalPriceLabel.rx.text)
            .disposed(by: disposeBag)

        output.deleteAlertAction
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, output in
                switch output.0 {
                case .delete:
                    guard var section = try? self.tableViewItemSubject.value() else { return }
                    section[output.1.section].items.remove(at: output.1.item)
                    owner.tableViewItemSubject.onNext(section)
                    owner.tableView.reloadData()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    private enum Namespace {
        static let deleteImage = "trash.circle"
        static let modifyImage = "arrow.backward"
        static let cancelActionTitle = "취소"
        static let deleteActionTitle = "삭제"
        static let alertTitle = "해당 상품을 장바구니에서 삭제하시겠습니까?"
    }
}

extension CartViewController {
    func showDeleteAlert() -> Observable<AlertActionType> {
        return Observable.create { [weak self] emitter in
            let cancelAction = UIAlertAction(title: Namespace.cancelActionTitle,
                                             style: .cancel) { _ in
                emitter.onNext(.cancel)
                emitter.onCompleted()
            }

            let deleteAction = UIAlertAction(title: Namespace.deleteActionTitle,
                                             style: .destructive) { _ in
                emitter.onNext(.delete)
                emitter.onCompleted()
            }

            let alert = AlertManager.shared
                .setType(.alert)
                .setTitle(Namespace.alertTitle)
                .setMessage(nil)
                .setActions([cancelAction, deleteAction])
                .apply()

            self?.navigationController?.present(alert, animated: true)

            return Disposables.create {
                alert.dismiss(animated: true)
            }
        }
    }
}
