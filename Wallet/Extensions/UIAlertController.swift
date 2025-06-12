//
//  UIAlertController.swift
//  Wallet
//
//  Created by Yuriy on 05.06.2025.
//

import UIKit

extension UIAlertController {
    static func create(
        title: String? = nil,
        message: String? = nil,
        preferredStyle: UIAlertController.Style,
        actions: (title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?)...
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { actionInfo in
            let action = UIAlertAction(title: actionInfo.title, style: actionInfo.style, handler: actionInfo.handler)
            alert.addAction(action)
        }
        return alert
    }
}
