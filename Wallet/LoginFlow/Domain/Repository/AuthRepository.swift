//
//  AuthRepository.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import Foundation


protocol AuthRepository {
    func login(_ credentials: LoginCredentials) throws
}
