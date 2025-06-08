//
//  Protocols.swift
//  Wallet
//
//  Created by Yuriy on 08.06.2025.
//

import Foundation

// VC -> Presenter

protocol LoginPresenter {
    func bindView(_ view: LoginViewDelegate)
    func viewDidLoad()
    func didTapLogin(username: String, password: String)
}

// Presenter -> Coordinator

protocol LoginPresenterOutput: AnyObject {
    func loginDidFinish()
}


// Presenter -> VC.
protocol LoginViewDelegate: AnyObject {
    func setLoading(_ loading: Bool)
    func showError(_ message: String)
}

