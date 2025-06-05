//
//  UIControl.swift
//  Wallet
//
//  Created by Yuriy on 05.06.2025.
//

import UIKit

extension UIControl {
    func addAction(for event: UIControl.Event, handler: @escaping UIActionHandler) {
        self.addAction(UIAction(handler:handler), for:event)
    }
}

