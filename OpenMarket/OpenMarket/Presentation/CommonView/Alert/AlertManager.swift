//
//  AlertManager.swift
//  OpenMarket
//
//  Created by 정선아 on 2023/06/13.
//

import UIKit
import RxSwift

final class AlertManager {
    struct AlertComponents {
        var title: String?
        var message: String?
        var type: UIAlertController.Style = .alert
        var actions: [UIAlertAction] = []
    }

    static private let alertManager = AlertManager()
    static private var components = AlertComponents()

    static var shared: AlertManager {
        self.components = AlertComponents()
        return alertManager
    }

    private init() { }

    func setTitle(_ title: String) -> AlertManager {
        Self.components.title = title

        return self
    }

    func setMessage(_ message: String?) -> AlertManager {
        Self.components.message = message

        return self
    }

    func setType(_ type: UIAlertController.Style) -> AlertManager {
        Self.components.type = type

        return self
    }

    func setActions(_ actions: [UIAlertAction]?) -> AlertManager {
        guard let actions = actions else { return self }
        actions.forEach { Self.components.actions.append($0) }

        return self
    }

    func apply() -> UIAlertController {
        let alert = UIAlertController(
            title: AlertManager.components.title,
            message: AlertManager.components.message,
            preferredStyle: AlertManager.components.type
        )

        AlertManager
            .components
            .actions
            .forEach { alert.addAction($0) }

        return alert
    }
}

