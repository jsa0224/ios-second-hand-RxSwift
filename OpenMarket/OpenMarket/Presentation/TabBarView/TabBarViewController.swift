//
//  TabBarViewController.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/05/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }

    private func configureTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(named: "selectedColor")
        tabBar.unselectedItemTintColor = UIColor(named: "mainColor")

        let networkManager = ItemNetworkManager()
        let coreDataManager = CoreDataManager.shared

        let itemListRepository = ItemRepository(networkManager: networkManager)
        let itemDetailRepository = ItemDetailRepository(coreDataManager: coreDataManager)

        let itemListUseCase = ItemListUseCase(itemListRepository: itemListRepository)
        let itemUseCase = ItemUseCase(itemRepository: itemDetailRepository)

        let homeViewModel = HomeViewModel(itemListUseCase: itemListUseCase)
        let cartViewModel = CartViewModel(itemUseCase: itemUseCase)

        let homeViewController = HomeViewController(viewModel: homeViewModel)
        let cartViewController = CartViewController(viewModel: cartViewModel)

        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let cartNavigationController = UINavigationController(rootViewController: cartViewController)

        homeNavigationController.navigationBar.scrollEdgeAppearance = homeNavigationController.navigationBar.standardAppearance
        cartNavigationController.navigationBar.scrollEdgeAppearance = cartNavigationController.navigationBar.standardAppearance

        viewControllers = [homeNavigationController, cartNavigationController]

        let homeImage = UIImage(systemName: Namespace.homeImage)
        let homeTabBarItem = UITabBarItem(title: Namespace.homeTitle,
                                          image: homeImage,
                                          tag: 0)

        let cartImage = UIImage(systemName: Namespace.cartImage)
        let cartTabBarItem = UITabBarItem(title: Namespace.cartTitle,
                                          image: cartImage,
                                          tag: 1)

        homeNavigationController.tabBarItem = homeTabBarItem
        cartNavigationController.tabBarItem = cartTabBarItem
    }

    private enum Namespace {
        static let homeImage = "house"
        static let homeTitle = "home"
        static let cartImage = "cart.fill"
        static let cartTitle = "cart"
    }
}
