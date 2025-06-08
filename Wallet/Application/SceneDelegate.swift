//
//  SceneDelegate.swift
//  Wallet
//
//  Created by Yuriy on 05.06.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    
    var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let coordinator = AppCoordinator(
            preferences: .shared,
            window: window
        )
        self.coordinator = coordinator
        self.coordinator?.start()
    }
}

