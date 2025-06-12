//
//  CoinCoordinator.swift
//  Wallet
//
//  Created by Yuriy on 11.06.2025.
//

import UIKit

final class CoinCoordinator: Coordinator {

    private weak var navigation: UINavigationController?
    private let model: Coin

    var childs: [Coordinator] = []
    var didRequestLogout: (() -> Void)?
    var didFinish: (() -> Void)?

    init(navigation: UINavigationController, model: Coin) {
        self.navigation = navigation
        self.model = model
    }

    func start() {
        let detailVC = CoinViewControllerFactory.make(coordinator: self, model: model)
        navigation?.pushViewController(detailVC, animated: true)
    }
    
    deinit {
#if DEBUG
        print("Deinit - \(self)")
#endif
    }

}

// MARK: - Detail‑screen -> CoinCoordinator

protocol CoinCoordinatorOutput: AnyObject {
    func logoutFromDetail()
    func close()
}

extension CoinCoordinator: CoinCoordinatorOutput {
    func logoutFromDetail() {
        didRequestLogout?()
        close()
    }

    func close() {
        navigation?.popViewController(animated: true)
        didFinish?()
    }
}

