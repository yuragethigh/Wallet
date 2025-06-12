//
//  UIView.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import UIKit

extension UIView {
    func turnoffTAMIC() {
        subviews.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

