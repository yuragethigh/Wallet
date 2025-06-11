//
//  HomeViewController + Ext.swift
//  Wallet
//
//  Created by Yuriy on 10.06.2025.
//

import UIKit

extension HomeViewController {
    
    struct HomeModel {
        struct Coin {
            let name: String
            let symbol: String
            let price: String
            let change: String
            let icon: UIImage
        }
        let coin: [Coin]
        let sortType: SortMenuItem
    }
}

extension HomeViewController {
    enum HomeViewSection: CaseIterable {
        case header, coins
    }
}

