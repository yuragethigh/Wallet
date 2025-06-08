//
//  Coordinator.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import Foundation

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    func start()
}
