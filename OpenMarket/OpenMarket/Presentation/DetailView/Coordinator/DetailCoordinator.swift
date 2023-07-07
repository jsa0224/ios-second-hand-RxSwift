//
//  DetailCoordinator.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/07/07.
//

import UIKit
import RxSwift

final class DetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let itemUseCase: ItemUseCaseType
    private let imageUseCase: ImageUseCaseType

    init(navigationController: UINavigationController,
         parentCoordinator: Coordinator,
         itemUseCase: ItemUseCaseType,
         imageUseCase: ImageUseCaseType) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.itemUseCase = itemUseCase
        self.imageUseCase = imageUseCase
    }

    func start(with item: Item) {
        let detailViewModel = DetailViewModel(itemUseCase: itemUseCase,
                                              imageUseCase: imageUseCase,
                                              item: item)
        let detailViewController = DetailViewController(viewModel: detailViewModel,
                                                        coordinator: self)
        self.navigationController.pushViewController(
            detailViewController,
            animated: true
        )
    }

    func moveToFavoriteView(by viewController: UIViewController) {
        viewController.tabBarController?.selectedIndex = 1
    }

    func moveToCartView(by viewController: UIViewController) {
        viewController.tabBarController?.selectedIndex = 2
    }

    func configureAlert(message: String) {
        let confirmAction = UIAlertAction(title: AlertMessage.confirm,
                                          style: .default)

        let alert = AlertManager.shared
            .setType(.alert)
            .setTitle(message + AlertMessage.registerAlertMessage)
            .setActions([confirmAction])
            .apply()

        navigationController.present(alert, animated: true)
    }

    private enum AlertMessage {
        static let confirm = "확인"
        static let registerAlertMessage = "에 등록되었습니다."
    }
}

