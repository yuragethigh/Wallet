//
//  HardcodedAuthRepository.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import Foundation

final class HardcodedAuthRepository: AuthRepository {
    private let valid = LoginCredentials(username: "1234", password: "1234")
    
    func login(_ credentials: LoginCredentials) throws {
        guard credentials == valid else {
            throw AuthError.invalidCredentials
        }
    }
}

