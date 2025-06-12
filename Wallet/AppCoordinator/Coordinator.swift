//
//  Coordinator.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import Foundation

protocol Coordinator: AnyObject {
    var childs: [Coordinator] { get }
    func start()
}

