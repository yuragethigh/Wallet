//
//  TabbarCoordinator.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import UIKit

final class TabbarCoordinator: Coordinator {
    var childs: [Coordinator] = []
    var controller: UIViewController?
    var didFinishFlow: (() -> Void)?
    
    func start() {
        let vc = TabbarController()
        controller = vc
    }
}


