//
//  LargeAreaButton.swift
//  Wallet
//
//  Created by Yuriy on 09.06.2025.
//
import UIKit

final class LargeAreaButton: UIButton {
    
    var touchAreaPadding: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    
    override func point(inside point: CGPoint,
                        with event: UIEvent?) -> Bool {
        let rect = bounds.inset(by: touchAreaPadding.inverted())
        return rect.contains(point)
    }
}

extension UIEdgeInsets {
    func inverted() -> Self {
        return .init(top: -top, left: -left, bottom: -bottom, right: -right)
    }
}
