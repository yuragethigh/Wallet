//
//  Protocols.swift
//  Wallet
//
//  Created by Yuriy on 10.06.2025.
//

import Foundation

// VC -> Interactor
protocol HomeBusinessLogic: AnyObject {
    func viewDidLoad()
    func refresh()
    func sort(sortType: SortMenuItem)
}

// Interactor -> Presenter
protocol HomePresentationLogic: AnyObject {
    func present(coins: [Coin], sortType: SortMenuItem)
}

//Presenter -> VC
protocol HomeDisplayLogic: AnyObject {
    func display(viewModel: HomeViewController.HomeModel)
}

