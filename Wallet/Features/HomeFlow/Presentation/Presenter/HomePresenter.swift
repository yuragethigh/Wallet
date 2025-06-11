//
//  HomePresenter.swift
//  Wallet
//
//  Created by Yuriy on 10.06.2025.
//

import Foundation

final class HomePresenter: HomePresentationLogic {
    
    weak var view: HomeDisplayLogic?
    
    func present(coins: [Coin], sortType: SortMenuItem) {
        
        let coin = coins.map {
            HomeViewController.HomeModel.Coin(
                name: $0.name,
                symbol: $0.symbol,
                price: $0.price.currencyFormat(),
                change: $0.change24h.percentFormat() + "%",
                icon: $0.change24h >= 0 ? .up : .down
            )
        }
        DispatchQueue.main.async {
            self.view?.display(viewModel: .init(coin: coin, sortType: sortType))
        }
    }
    
    deinit {
#if DEBUG
        print("Deinit - \(self)")
#endif
    }

}

