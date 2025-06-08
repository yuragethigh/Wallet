//
//  AppCoordinator.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private let preferences: Preferences
    private let window: UIWindow
    var childs: [Coordinator] = []
    
    init(preferences: Preferences, window: UIWindow) {
        self.preferences = preferences
        self.window = window
    }
    
    func start() {
        if preferences.isAuthorized {
            startMain()
        } else {
            startLogin()
        }
        window.makeKeyAndVisible()
    }
    
    private func startLogin() {
        let login = LoginCoordinator()
        login.start()
        childs.append(login)
        switchFlow(login.controller)
        login.didFinishFlow = { [weak self] in
            self?.preferences.isAuthorized = true
            self?.startMain()
            self?.childs.removeAll(where: { $0 === login })
        }
    }
    
    private func startMain() {
        let tabbarCoordinator = TabbarCoordinator()
        tabbarCoordinator.start()
        childs.append(tabbarCoordinator)
        switchFlow(tabbarCoordinator.controller)
        tabbarCoordinator.didFinishFlow = { [weak self] in
            self?.preferences.isAuthorized = false
            self?.startLogin()
            self?.childs.removeAll(where: { $0 === tabbarCoordinator })
        }
    }
}


fileprivate extension AppCoordinator {
    func switchFlow(_ controller: UIViewController?) {
        if let controller {
            let navController = UINavigationController(
                rootViewController: controller
            )
            window.rootViewController = navController
            UIView.transition(with: window,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
        
    }
}
