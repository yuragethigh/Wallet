//
//  LoginCoordinator.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import UIKit

final class LoginCoordinator: Coordinator {
    var childs: [Coordinator] = []
    
    var controller: UIViewController?
    var didFinishFlow: (() -> Void)?
    
    func start() {
        let loginFlow = LoginModuleFactory.make(output: self)
        controller = loginFlow
    }
}


extension LoginCoordinator: LoginPresenterOutput {
    func loginDidFinish() {
        didFinishFlow?()
    }
}


