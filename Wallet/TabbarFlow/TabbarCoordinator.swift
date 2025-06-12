//
//  TabbarCoordinator.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import UIKit

final class TabbarCoordinator: Coordinator {

    let tabbarController = TabbarController()
    var childs: [Coordinator] = []
    var didFinishFlow: (() -> Void)?

    func start() {
        setupTabs()
    }

    private func setupTabs() {
        let home = HomeCoordinator()
        home.didRequestLogout = { [weak self] in
            self?.childs.removeAll()
            self?.didFinishFlow?()
        }
        tabbarController.tabbarItemConfigure(vc: home.controller, image: .homeTab, tag: 0)
        add(child: home)
        
        
        // etc
        let emptyVC = UIViewController()
        tabbarController.tabbarItemConfigure(vc: emptyVC, image: .etcTab, tag: 1)
        

        tabbarController.configure(with: [home.controller, emptyVC])
    }

    private func add(child coordinator: Coordinator) {
        childs.append(coordinator)
        coordinator.start()
    }
    
    deinit {
#if DEBUG
        print("Deinit - \(self)")
#endif
    }

}


