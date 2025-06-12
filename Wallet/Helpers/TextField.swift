//
//  TextField.swift
//  Wallet
//
//  Created by Yuriy on 05.06.2025.
//

import UIKit

class TextField: UITextField {
   override var placeholder: String? {
        didSet {
            let placeholderString = NSAttributedString(
                string: placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.color9395A4]
            )
            self.attributedPlaceholder = placeholderString
        }
    }
}

