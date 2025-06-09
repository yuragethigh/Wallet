//
//  TabbarController.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import UIKit

final class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
    }

    func configure(with viewControllers: [UIViewController]) {
        setViewControllers(viewControllers, animated: false)
    }
}
