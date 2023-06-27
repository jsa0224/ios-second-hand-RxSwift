//
//  HomeViewController.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewController: UIViewController {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<ItemSection>
    
    private let viewModel: HomeViewModel
    private var disposeBag = DisposeBag()
    private var collectionView: UICollectionView?
    private var itemListDataSource = DataSource { _, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemGridCollectionViewCell.identifier,
                                                            for: indexPath) as? ItemGridCollectionViewCell else {
            return ItemGridCollectionViewCell()
        }

        cell.bind(item)

        return cell
    }

    init(viewModel: HomeViewModel, disposeBag: DisposeBag = DisposeBag()) {
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
        configureHierarchy()
        configureDataSource()
        bind()
    }

    private func configureUI() {
        let image = UIImage(named: "SecondHand")
        navigationItem.titleView = UIImageView(image: image)
        navigationItem.titleView?.contentMode = .scaleAspectFit
        self.view.backgroundColor = .white
    }

    private func bind() {
        guard let collectionView = collectionView else {
            return
        }

        let didShowView = self.rx.viewWillAppear.asObservable()
        let didScrollBottom = collectionView.rx.prefetchItems
            .map { $0.last?.row }

        let input = HomeViewModel.Input(didShowView: didShowView,
                                        didScrollBottom: didScrollBottom)
        let output = viewModel.transform(input)

        output
            .itemList
            .withUnretained(self)
            .map { owner, item in
                [ItemSection(items: item)]
            }
            .bind(to: collectionView.rx.items(dataSource: itemListDataSource))
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(Item.self)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, item in
                let networkManager = ItemNetworkManager()
                let coreDataManager = CoreDataManager.shared
                let itemRepository = ItemRepository(networkManager: networkManager)
                let itemDetailRepository = ItemDetailRepository(coreDataManager: coreDataManager)
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

    private enum Layout {
        static let spacing: CGFloat = 8
        static let fractionalWidth: CGFloat = 0.5
        static let fractionalHeight: CGFloat = 1.0
        static let groupSizeFractionalHeight: CGFloat = 0.3
        static let contentInsets: CGFloat = 10
    }
}

extension HomeViewController {
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Layout.fractionalWidth),
                                              heightDimension: .fractionalHeight(Layout.fractionalHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(Layout.groupSizeFractionalHeight))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 2)
        group.interItemSpacing = .fixed(Layout.spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Layout.spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: Layout.contentInsets,
                                                        leading: Layout.contentInsets,
                                                        bottom: Layout.contentInsets,
                                                        trailing: Layout.contentInsets)

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createGridLayout())
        guard let collectionView = collectionView else {
            return
        }

        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor(named: "mainColor")
        self.view.addSubview(collectionView)
    }

    private func configureDataSource() {
        guard let collectionView = collectionView else {
            return
        }

        collectionView.register(ItemGridCollectionViewCell.self,
                                forCellWithReuseIdentifier: ItemGridCollectionViewCell.identifier)
    }
}
