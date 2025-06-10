//
//  Double.swift
//  Wallet
//
//  Created by Yuriy on 10.06.2025.
//

import Foundation

extension Double {
    func currencyFormat() -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.currencyCode = "USD"
        fmt.maximumFractionDigits = 2
        return fmt.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Double {
    func percentFormat(_ maxDigit: Int = 1) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.maximumFractionDigits = maxDigit
        return fmt.string(from: NSNumber(value: self)) ?? ""

    }
}

