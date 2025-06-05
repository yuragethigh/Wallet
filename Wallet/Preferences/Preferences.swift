//
//  Preferences.swift
//  Wallet
//
//  Created by Yuriy on 05.06.2025.
//

import Foundation

final class Preferences {
    
    static let shared = Preferences(); private init() {}
    
    @UserDefault(Preferences.Key.isAuthorized) var isAuthorized = false

    private enum Key {
        static let isAuthorized = "isAuthorized"
    }
}
