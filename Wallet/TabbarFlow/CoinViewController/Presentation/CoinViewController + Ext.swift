//
//  CoinViewController + Ext.swift
//  Wallet
//
//  Created by Yuriy on 11.06.2025.
//

import UIKit

extension CoinViewController {
    struct ViewModel {
        struct Coin {
            let navtitle: String
            let price: String
            let change: String
            let icon: UIImage?
            let cap: String
            let suply: String
        }
        let coin: Coin
    }
}

extension CoinViewController {
    enum TabelViewSection: CaseIterable {
        case info, switcher
    }
}

