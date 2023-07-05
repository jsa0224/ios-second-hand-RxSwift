//
//  SearchViewController.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/07/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class SearchViewController: UIViewController {
    typealias DataSource = RxTableViewSectionedReloadDataSource<ItemSection>

    private let viewModel: SearchViewModel
    private var disposeBag = DisposeBag()
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = SearchBar.placeHolder
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        return searchController
    }()
    private var tableView = UITableView()
    private var itemListDataSource = DataSource { _, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier,
                                                       for: indexPath) as? ItemTableViewCell else {
            return ItemTableViewCell()
        }

        cell.bind(item)

        return cell
    }

    init(viewModel: SearchViewModel, disposeBag: DisposeBag = DisposeBag()) {
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
        let image = UIImage(named: Image.secondHand)
        navigationItem.titleView = UIImageView(image: image)
        navigationItem.titleView?.contentMode = .scaleAspectFit
        self.view.backgroundColor = .white

        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false

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
        let searchItems = searchController.searchBar.rx.searchButtonClicked
            .withUnretained(self)
            .withLatestFrom(
                searchController.searchBar.rx.text
                    .orEmpty
            )
            .map { $0 }

        let input = SearchViewModel.Input(didEndSearching: searchItems)
        let output = viewModel.transform(input, disposeBag)

        output
            .itemList
            .withUnretained(self)
            .map { owner, item in
                [ItemSection(items: item)]
            }
            .bind(to: tableView.rx.items(dataSource: itemListDataSource))
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Item.self)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, item in
                let networkManager = ItemNetworkManager()
                let coreDataManager = CoreDataManager.shared
                let itemRepository = ItemListRepository(networkManager: networkManager)
                let itemDetailRepository = ItemRepository(coreDataManager: coreDataManager)
                let itemUseCase = ItemUseCase(itemRepository: itemDetailRepository)
                let imageUseCase = ImageUseCase(imageRepository: itemRepository)
                let detailViewModel = DetailViewModel(itemUseCase: itemUseCase,
                                                      imageUseCase: imageUseCase,
                                                      item: item)
                let detailViewController = DetailViewController(viewModel: detailViewModel
                )
                owner.navigationController?.pushViewController(detailViewController,
                                                               animated: true)
            })
            .disposed(by: disposeBag)
    }

    private enum TableViewLayout {
        static let rowHeight: CGFloat = 100
    }

    private enum SearchBar {
        static let placeHolder = "상품 이름으로 검색"
    }
}
