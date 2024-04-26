//
//  FavoriteViewController.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/30.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class FavoriteViewController: UIViewController {
    typealias DataSource = RxTableViewSectionedReloadDataSource<ItemSection>

    private let viewModel: FavoriteViewModel
    private let coordinator: FavoriteCoordinator
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

    init(viewModel: FavoriteViewModel,
         coordinator: FavoriteCoordinator,
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
        let image = UIImage(named: Image.secondHand)
        navigationItem.titleView = UIImageView(image: image)
        navigationItem.titleView?.contentMode = .scaleAspectFit
        self.view.backgroundColor = .white

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ItemTableViewCell.self,
                           forCellReuseIdentifier: ItemTableViewCell.identifier)
        self.view.addSubview(tableView)
        tableView.rowHeight = TableViewLayout.rowHeight

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func bind() {
        let didShowView = self.rx.viewWillAppear.asObservable()
        let deleteAction = tableView.rx.itemDeleted
            .withUnretained(self)
            .flatMap { owner, indexPath in
                owner.coordinator.showDeleteAlert()
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

        let input = FavoriteViewModel.Input(didShowView: didShowView,
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

    private enum TableViewLayout {
        static let rowHeight: CGFloat = 100
    }
}
