//
//  AppCoordinator.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/07/07.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    private let itemListUseCase: ItemListUseCaseType = ItemListUseCase(
        itemListRepository: ItemListRepository(networkManager: ItemNetworkManager()))
    private let itemUseCase: ItemUseCaseType = ItemUseCase(
        itemRepository: ItemRepository(coreDataManager: CoreDataManager.shared))
    private let imageUseCase: ImageUseCaseType = ImageUseCase(
        imageRepository: ItemListRepository(networkManager: ItemNetworkManager()))

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = .selected
        tabBarController.tabBar.unselectedItemTintColor = .main

        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem = UITabBarItem(
            title: Namespace.homeTitle,
            image: UIImage(systemName: Namespace.homeImage),
            tag: Tag.home
        )
        homeNavigationController.navigationBar.scrollEdgeAppearance = homeNavigationController.navigationBar.standardAppearance

        let favoriteNavigationController = UINavigationController()
        favoriteNavigationController.tabBarItem = UITabBarItem(
            title: Namespace.favoriteTitle,
            image: UIImage(systemName: Namespace.heartImage),
            tag: Tag.favorite
        )
        favoriteNavigationController.navigationBar.scrollEdgeAppearance = favoriteNavigationController.navigationBar.standardAppearance

        let cartNavigationController = UINavigationController()
        cartNavigationController.tabBarItem = UITabBarItem(
            title: Namespace.cartTitle,
            image: UIImage(systemName: Namespace.cartImage),
            tag: Tag.cart
        )
        cartNavigationController.navigationBar.scrollEdgeAppearance = cartNavigationController.navigationBar.standardAppearance

        tabBarController.viewControllers = [
            homeNavigationController,
            favoriteNavigationController,
            cartNavigationController
        ]
        navigationController.viewControllers = [tabBarController]
        navigationController.setNavigationBarHidden(true, animated: false)

        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController,
                                              parentCoordinator: self,
                                              itemListUseCase: itemListUseCase,
                                              itemUseCase: itemUseCase,
                                              imageUseCase: imageUseCase)

        let favoriteCoordinator = FavoriteCoordinator(navigationController: favoriteNavigationController,
                                                      parentCoordinator: self,
                                                      itemUseCase: itemUseCase)

        let cartCoordinator = CartCoordinator(navigationController: cartNavigationController,
                                              parentCoordinator: self,
                                              itemUseCase: itemUseCase)

        childCoordinators.append(homeCoordinator)
        childCoordinators.append(favoriteCoordinator)
        childCoordinators.append(cartCoordinator)
        homeCoordinator.start()
        favoriteCoordinator.start()
        cartCoordinator.start()
    }

    private enum Namespace {
        static let homeImage = "house"
        static let homeTitle = "home"
        static let cartImage = "cart.fill"
        static let cartTitle = "cart"
        static let heartImage = "heart.fill"
        static let favoriteTitle = "favorite"
    }

    private enum Tag {
        static let home = 0
        static let favorite = 1
        static let cart = 2
    }
}

