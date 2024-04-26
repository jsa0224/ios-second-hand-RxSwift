//
//  Coordinator.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/07/07.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
    func removeChildCoordinator(child: Coordinator) {
        childCoordinators.removeAll()
    }
}
