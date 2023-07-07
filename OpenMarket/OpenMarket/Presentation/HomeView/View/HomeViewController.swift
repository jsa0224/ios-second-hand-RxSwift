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
    private let coordinator: HomeCoordinator
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
    private let blankButton: UIBarButtonItem = {
        let searchImage = UIImage(systemName: Image.magnifyingGlass)
        let barButtonItem = UIBarButtonItem(image: searchImage,
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        barButtonItem.tintColor = .white
        return barButtonItem
    }()
    private let searchButton: UIBarButtonItem = {
        let searchImage = UIImage(systemName: Image.magnifyingGlass)
        let barButtonItem = UIBarButtonItem(image: searchImage,
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        barButtonItem.tintColor = .selected
        return barButtonItem
    }()

    init(viewModel: HomeViewModel,
         coordinator: HomeCoordinator,
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
        configureHierarchy()
        configureDataSource()
        bind()
    }

    private func configureUI() {
        let image = UIImage(named: Image.secondHand)
        navigationItem.titleView = UIImageView(image: image)
        navigationItem.titleView?.contentMode = .scaleAspectFit
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.leftBarButtonItem = blankButton
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
        let output = viewModel.transform(input, disposeBag)

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
                owner.coordinator.presentDetailView(with: item)
            })
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                owner.coordinator.presentSearchView()
            }
            .disposed(by: disposeBag)
    }

    private enum ItemSize {
        static let fractionalWidth: CGFloat = 0.5
        static let fractionalHeight: CGFloat = 1.0
    }

    private enum GroupSize {
        static let fractionalWidth: CGFloat = 1.0
        static let fractionalHeight: CGFloat = 0.3
    }

    private enum Group {
        static let count = 2
    }

    private enum Layout {
        static let spacing: CGFloat = 8
        static let contentInsets: CGFloat = 10
    }
}

extension HomeViewController {
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(ItemSize.fractionalWidth),
                                              heightDimension: .fractionalHeight(ItemSize.fractionalHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(GroupSize.fractionalWidth),
                                               heightDimension: .fractionalHeight(GroupSize.fractionalHeight))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: Group.count)
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
        collectionView.backgroundColor = .main
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
