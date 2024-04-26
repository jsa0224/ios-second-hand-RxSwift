//
//  HomeCoordinator.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/07/07.
//

import UIKit

final class HomeCoordinator: Coordinator {
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
        let homeViewModel = HomeViewModel(itemListUseCase: itemListUseCase)
        let homeViewController = HomeViewController(viewModel: homeViewModel,
                                                    coordinator: self)
        navigationController.pushViewController(homeViewController, animated: true)
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

    func presentSearchView() {
        let searchCoordinator = SearchCoordinator(navigationController: navigationController,
                                                  parentCoordinator: self,
                                                  itemListUseCase: itemListUseCase,
                                                  itemUseCase: itemUseCase,
                                                  imageUseCase: imageUseCase)
        childCoordinators.append(searchCoordinator)
        searchCoordinator.start()
    }
}
