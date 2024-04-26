//
//  CartCoordinator.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/07/07.
//

import UIKit
import RxSwift

final class CartCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let itemUseCase: ItemUseCaseType

    init(navigationController: UINavigationController,
         parentCoordinator: Coordinator,
         itemUseCase: ItemUseCaseType) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.itemUseCase = itemUseCase
    }

    func start() {
        let cartViewModel = CartViewModel(itemUseCase: itemUseCase)
        let cartViewController = CartViewController(viewModel: cartViewModel,
                                                    coordinator: self)
        navigationController.pushViewController(cartViewController,
                                                animated: true)
    }

    func showDeleteAlert() -> Observable<AlertActionType> {
        return Observable.create { [weak self] emitter in
            let cancelAction = UIAlertAction(title: AlertText.cancelActionTitle,
                                             style: .cancel) { _ in
                emitter.onNext(.cancel)
                emitter.onCompleted()
            }

            let deleteAction = UIAlertAction(title: AlertText.deleteActionTitle,
                                             style: .destructive) { _ in
                emitter.onNext(.delete)
                emitter.onCompleted()
            }

            let alert = AlertManager.shared
                .setType(.alert)
                .setTitle(AlertText.alertTitle)
                .setMessage(nil)
                .setActions([cancelAction, deleteAction])
                .apply()

            self?.navigationController.present(alert, animated: true)

            return Disposables.create {
                alert.dismiss(animated: true)
            }
        }
    }

    private enum AlertText {
        static let cancelActionTitle = "취소"
        static let deleteActionTitle = "삭제"
        static let alertTitle = "해당 상품을 장바구니에서 삭제하시겠습니까?"
    }
}


