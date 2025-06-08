//
//  AuthenticateUseCase.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import Foundation

protocol AuthenticateUseCase {
    func execute(_ credentials: LoginCredentials) throws
}

final class AuthenticateUseCaseImpl: AuthenticateUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(_ credentials: LoginCredentials) throws {
        try repository.login(credentials)
    }
}

