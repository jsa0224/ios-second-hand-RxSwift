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
        let itemListRepository = ItemRepository(networkManager: networkManager)
        let itemListUseCase = ItemListUseCase(itemListRepository: itemListRepository)
        let homeViewModel = HomeViewModel(itemListUseCase: itemListUseCase)
        let homeViewController = HomeViewController(viewModel: homeViewModel)

        let homeNavigationController = UINavigationController(rootViewController: homeViewController)

        homeNavigationController.navigationBar.scrollEdgeAppearance = homeNavigationController.navigationBar.standardAppearance

        viewControllers = [homeNavigationController]

        let homeImage = UIImage(systemName: Namespace.homeImage)
        let homeTabBarItem = UITabBarItem(title: Namespace.homeTitle,
                                          image: homeImage,
                                          tag: 0)

        homeNavigationController.tabBarItem = homeTabBarItem
    }

    func configureLayout() {
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tabBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
    }

    private enum Namespace {
        static let homeImage = "house"
        static let homeTitle = "home"

    }
}
