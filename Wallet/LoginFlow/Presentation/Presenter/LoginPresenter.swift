//
//  LoginPresenter.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import Foundation

final class LoginPresenterImpl: LoginPresenter {
    
    private weak var view: LoginViewDelegate?
    weak var output: LoginCoordinatorOutput?
    private let authenticate: AuthenticateUseCase
    
    init(authenticate: AuthenticateUseCase) {
        self.authenticate = authenticate
    }
    
    deinit {
#if DEBUG
        print("Deinit - \(self)")
#endif
    }

    
    func bindView(_ view: LoginViewDelegate) {
        self.view = view
    }
    
    func viewDidLoad() {}
    
    func didTapLogin(username: String, password: String) {
        let credentials = LoginCredentials(username: username, password: password)
        view?.setLoading(true)
        do {
            try authenticate.execute(credentials)
            output?.loginDidFinish()
        } catch let error as AuthError {
            view?.showError(error.errorDescription)
        } catch {
            view?.showError(AuthError.unknown(error).errorDescription)
        }
        
        view?.setLoading(false)
    }
}

