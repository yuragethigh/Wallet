//
//  HomeCoordinator.swift
//  Wallet
//
//  Created by Yuriy on 11.06.2025.
//

import UIKit



final class HomeCoordinator: Coordinator {

    let controller = UINavigationController()
    var childs: [Coordinator] = []
    var didRequestLogout: (() -> Void)?

    func start() {
        let homeVC = HomeViewControllerFactory.make(coordinator: self)
        controller.viewControllers = [homeVC]
    }
    
    deinit {
#if DEBUG
        print("Deinit - \(self)")
#endif
    }
}

// MARK: - Home‑screen -> HomeCoordinator

protocol HomeCoordinatorOutput: AnyObject {
    func logout()
    func presentDetail(model: Coin)
}


extension HomeCoordinator: HomeCoordinatorOutput {
    func logout() {
        didRequestLogout?()
    }
    
    func presentDetail(model: Coin) {
        let coinCoordinator = CoinCoordinator(navigation: controller, model: model)
        coinCoordinator.start()
        childs.append(coinCoordinator)
        
        coinCoordinator.didRequestLogout = { [weak self] in self?.didRequestLogout?() }
        coinCoordinator.didFinish = { [weak self, weak coinCoordinator] in
            guard let self, let coinCoordinator else { return }
            self.childs.removeAll { $0 === coinCoordinator }
        }

    }
}


