//
//  UIFont.swift
//  Wallet
//
//  Created by Yuriy on 05.06.2025.
//
import UIKit

extension UIFont {
    static func poppins(weight: Weight, size: CGFloat) -> UIFont {
        
        var fontName = "Poppins-"
        
        switch weight {
        case .regular: fontName += "Regular"
        case .medium: fontName += "Medium"
        case .semibold: fontName += "SemiBold"
            
        default:
            fatalError("This font doesn't exist")
        }
        
        return UIFont(name: fontName, size: size)!
    }
}
