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
        setupAppearance()
    }
    
    func tabbarItemConfigure(
        vc: UIViewController,
        image: UIImage,
        tag: Int
    ) {
        let tabBarItem = UITabBarItem(title: nil, image: image, tag: tag)
        vc.tabBarItem = tabBarItem
    }
    
    private func setupAppearance() {
        let tabBar = UITabBar.appearance()
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.shadowColor = .none
        tabBar.isTranslucent = false
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.colorCED0DE
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.color26273C
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }


    func configure(with viewControllers: [UIViewController]) {
        setViewControllers(viewControllers, animated: false)
    }
}
