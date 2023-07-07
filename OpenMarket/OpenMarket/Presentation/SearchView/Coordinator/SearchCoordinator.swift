//
//  SearchCoordinator.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/07/07.
//

import UIKit

final class SearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let itemListUseCase: ItemListUseCaseType
    private let itemUseCase: ItemUseCaseType
    private let imageUseCase: ImageUseCaseType

    init(navigationController: UINavigationController,
         parentCoordinator: Coordinator,
         itemListUseCase: ItemListUseCaseType,
         itemUseCase: ItemUseCaseType,
         imageUseCase: ImageUseCaseType) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.itemListUseCase = itemListUseCase
        self.itemUseCase = itemUseCase
        self.imageUseCase = imageUseCase
    }

    func start() {
        let searchViewModel = SearchViewModel(itemListUseCase: itemListUseCase)
        let searchViewController = SearchViewController(viewModel: searchViewModel,
                                                        coordinator: self)
        self.navigationController.pushViewController(
            searchViewController,
            animated: true
        )
    }

    func presentDetailView(with item: Item) {
        let detailCoordinator = DetailCoordinator(
            navigationController: navigationController,
            parentCoordinator: self,
            itemUseCase: itemUseCase,
            imageUseCase: imageUseCase
        )
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start(with: item)
    }
}
