//
//  CoinPresenter.swift
//  Wallet
//
//  Created by Yuriy on 11.06.2025.
//

import Foundation

final class CoinPresenter: CoinPresentationLogic {
    weak var view: CoinDisplayLogic?
    
    func present(coin: Coin) {
        
        let viewModel: CoinViewController.ViewModel = .init(
            coin: .init(
                navtitle: coin.name + " (\(coin.symbol.uppercased()))",
                price: coin.price.currencyFormat(),
                change: coin.change24h.percentFormat() + "%",
                icon: coin.change24h.roundedTo(1) > 0 ? .up : (coin.change24h.roundedTo(1) < 0 ? .down : nil),
                cap: 245356.00.currencyFormat(0),
                suply: 1234.234.percentFormat(3) + " \(coin.symbol.uppercased())"
            )
        )
        view?.display(viewModel: viewModel)
    }
}

