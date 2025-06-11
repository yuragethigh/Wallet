//
//  LoginModuleFactory.swift
//  Wallet
//
//  Created by Yuriy on 10.06.2025.
//

import UIKit

struct LoginModuleFactory {
    static func make(output: LoginCoordinatorOutput? = nil) -> UIViewController {
        let repository = HardcodedAuthRepository()
        let useCase = AuthenticateUseCaseImpl(repository: repository)
        let presenter = LoginPresenterImpl(authenticate: useCase)
        presenter.output = output
        let view = LoginViewController(presenter: presenter)
        return view
    }
}

