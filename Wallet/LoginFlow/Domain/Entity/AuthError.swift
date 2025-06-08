//
//  AuthError.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import Foundation

enum AuthError: Error {
    case invalidCredentials
    case unknown(Error)
    
    var errorDescription: String {
        switch self {
        case .invalidCredentials:
            return "Введены неправильный логин или пароль"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

