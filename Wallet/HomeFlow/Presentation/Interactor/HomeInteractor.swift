//
//  HomeInteractor.swift
//  Wallet
//
//  Created by Yuriy on 10.06.2025.
//

import Foundation


final class HomeInteractor: HomeBusinessLogic {
    
    private let repo: CryptoRepository
    private let presenter: HomePresentationLogic
    private let symbols = [
        "btc","eth","tron","luna","polkadot",
        "dogecoin","tether","stellar","cardano","xrp"
    ]
    private var coins = [Coin]()
    private var sortType: SortMenuItem = .none
    private let workQueue = DispatchQueue(
        label: "home.interactor.work",
        qos: .userInitiated
    )

    
    init(
        repo: CryptoRepository,
        presenter: HomePresentationLogic
    ) {
        self.repo = repo
        self.presenter = presenter
    }
    
    //MARK: - Public
    
    func viewDidLoad() {
        load()
    }
    
    func refresh(){
        workQueue.async { [weak self] in
            self?.load()
        }
    }
    
    func sort(sortType: SortMenuItem) {
        workQueue.async { [weak self] in
            guard let self else { return }
            self.sortType = sortType
            present(coins)
        }
    }
    
    //MARK: - Private

    private func load() {
        coins.removeAll()
        coins.reserveCapacity(symbols.count)
        
        repo.loadMetrics(for: symbols) { [weak self] result in
            switch result {
            case .success(let list):
                self?.coins = list
                self?.present(list)
                
            case .failure(_):
//                print(err)
                //TODO: - handle error
                break
            }
        }
    }
    
    private func present(_ list: [Coin]) {
        
        let sorted = list.sorted {
            switch sortType {
            case .none:
                return $0.price > $1.price
            case .up24:
                return $0.change24h < $1.change24h
            case .down24:
               return $0.change24h > $1.change24h
            }
        }
        presenter.present(coins: sorted, sortType: sortType)
    }
}

