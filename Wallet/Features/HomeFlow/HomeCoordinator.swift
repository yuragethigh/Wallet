//
//  HomeCoordinator.swift
//  Wallet
//
//  Created by Yuriy on 11.06.2025.
//

import UIKit

protocol HomeCoordinatorOutput: AnyObject {
    func logout()
    func presentDetail()
}

protocol DetailCoordinatorOutput: AnyObject {
    func logoutFromDetail()
}


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

extension HomeCoordinator: HomeCoordinatorOutput {
    func logout() {
        didRequestLogout?()
    }
    
    func presentDetail() {
        controller.pushViewController(UIViewController(), animated: true)
    }
}


extension HomeCoordinator: DetailCoordinatorOutput {
    func logoutFromDetail() {
        didRequestLogout?()
    }
}

