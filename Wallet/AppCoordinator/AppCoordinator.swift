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
            startTabbar()
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
        login.didFinishFlow = { [weak self, weak login] in
            self?.preferences.isAuthorized = true
            self?.childs.removeAll(where: { $0 === login })
            self?.startTabbar()

        }
    }
    
    private func startTabbar() {
        let tabbarCoordinator = TabbarCoordinator()
        tabbarCoordinator.start()
        childs.append(tabbarCoordinator)
        switchFlow(tabbarCoordinator.tabbarController)
        tabbarCoordinator.didFinishFlow = { [weak self, weak tabbarCoordinator] in
            self?.preferences.isAuthorized = false
            self?.childs.removeAll(where: { $0 === tabbarCoordinator })
            self?.startLogin()
        }
    }
}


fileprivate extension AppCoordinator {
    func switchFlow(_ controller: UIViewController?) {
        if let controller {
            window.rootViewController = controller
            UIView.transition(with: window,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
        
    }
}
