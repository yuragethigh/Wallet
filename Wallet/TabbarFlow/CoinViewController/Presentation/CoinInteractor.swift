//
//  CoinInteractor.swift
//  Wallet
//
//  Created by Yuriy on 11.06.2025.
//

import UIKit

final class CoinInteractor: CoinBuisnessLogic {
    
    private let presenter: CoinPresentationLogic
    private let coin: Coin
    
    init(coin: Coin, presenter: CoinPresentationLogic) {
        self.coin = coin
        self.presenter = presenter
    }
    
    func viewDidLoad() {
        presenter.present(coin: coin)
    }
}

