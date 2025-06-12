//
//  CoinViewLogic.swift
//  Wallet
//
//  Created by Yuriy on 11.06.2025.
//

import Foundation


// VC -> Interactor
protocol CoinBuisnessLogic: AnyObject {
    func viewDidLoad()
}


// Interactor -> Presenter
protocol CoinPresentationLogic: AnyObject {
    func present(coin: Coin)
}


//Presenter -> VC
protocol CoinDisplayLogic: AnyObject {
    func display(viewModel: CoinViewController.ViewModel)
}

