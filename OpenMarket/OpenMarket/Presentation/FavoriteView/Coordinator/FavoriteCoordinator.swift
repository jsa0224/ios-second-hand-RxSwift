//
//  FavoriteCoordinator.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/07/07.
//

import UIKit
import RxSwift

final class FavoriteCoordinator: Coordinator {
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
        let favoriteViewModel = FavoriteViewModel(itemUseCase: itemUseCase)
        let favoriteViewController = FavoriteViewController(viewModel: favoriteViewModel,
                                                            coordinator: self)
        navigationController.pushViewController(favoriteViewController, animated: true)
    }

    func showDeleteAlert() -> Observable<AlertActionType> {
        return Observable.create { [weak self] emitter in
            let cancelAction = UIAlertAction(title: AlertMessage.cancelActionTitle,
                                             style: .cancel) { _ in
                emitter.onNext(.cancel)
                emitter.onCompleted()
            }

            let deleteAction = UIAlertAction(title: AlertMessage.deleteActionTitle,
                                             style: .destructive) { _ in
                emitter.onNext(.delete)
                emitter.onCompleted()
            }

            let alert = AlertManager.shared
                .setType(.alert)
                .setTitle(AlertMessage.alertTitle)
                .setMessage(nil)
                .setActions([cancelAction, deleteAction])
                .apply()

            self?.navigationController.present(alert, animated: true)

            return Disposables.create {
                alert.dismiss(animated: true)
            }
        }
    }

    private enum AlertMessage {
        static let cancelActionTitle = "취소"
        static let deleteActionTitle = "삭제"
        static let alertTitle = "해당 상품을 관심상품에서 삭제하시겠습니까?"
    }
}

