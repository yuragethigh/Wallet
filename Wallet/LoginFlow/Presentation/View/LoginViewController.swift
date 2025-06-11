//
//  LoginViewController.swift
//  Wallet
//
//  Created by Yuriy on 05.06.2025.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - UI
    
    private let loginImageView: UIImageView = {
        $0.image = .group79Logo
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let usernameTextField: LoginViewTextField = {
        $0.iconImageView.image = .user
        $0.textField.placeholder = Strings.usernamePlaceholder
        return $0
    }(LoginViewTextField())
    
    private let passwordTextField: LoginViewTextField = {
        $0.iconImageView.image = .passwordiconss
        $0.textField.placeholder = Strings.passwordPlaceholder
        return $0
    }(LoginViewTextField())
    
    private lazy var loginButton: UIButton = {
        $0.setTitle(Strings.loginButtonTitle, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .poppins(weight: .semibold, size: 15)
        $0.backgroundColor = UIColor.color191C32
        $0.layer.cornerRadius = Constants.loginButtonCornerRadius
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor.color191C32.cgColor
        $0.layer.shadowOffset = Constants.loginButtonShadowOffset
        $0.layer.shadowRadius = Constants.loginButtonShadowRadius
        $0.layer.shadowOpacity = Constants.loginButtonShadowColorAlpha
        $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.setCustomSpacing(15, after: usernameTextField)
        $0.setCustomSpacing(25, after: passwordTextField)
        return $0
    }(UIStackView(arrangedSubviews: [usernameTextField, passwordTextField, loginButton]))
    
    private lazy var stackBottomConstraint: NSLayoutConstraint = {
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.stackBottomInitial)
    }()
    
    // MARK: - Dependencies
    
    private let presenter: LoginPresenter

    // MARK: - Initializers
    init(presenter: LoginPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.bindView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
#if DEBUG
        print("Deinit - \(self)")
#endif
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObserver()
        setupView()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObservers()
    }
    
    // MARK: - User Actions
    @objc private func buttonTapped() {
        presenter.didTapLogin(
            username: usernameTextField.textField.text ?? "",
            password: passwordTextField.textField.text ?? ""
        )
    }
        
    private func errorAlert(_ description: String) {
        let alert = UIAlertController.create(
            title: description,
            preferredStyle: .alert,
            actions:
                (Strings.cancel, .cancel, { [weak self] _ in self?.clearTextFields() }),
            (Strings.retry, .default, nil)
        )
        present(alert, animated: true)
    }
    
    private func clearTextFields() {
        usernameTextField.textField.text = nil
        passwordTextField.textField.text = nil
    }
    
    // MARK: - Layout
    private func setupView() {
        view.backgroundColor = .colorF3F5F6
        
        view.addSubview(loginImageView)
        view.addSubview(stackView)
        view.turnoffTAMIC()
        
        NSLayoutConstraint.activate([
            loginImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.loginImageTopInset),
            loginImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.loginImageSideInset),
            loginImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.loginImageSideInset),
            
            loginButton.heightAnchor.constraint(equalToConstant: Constants.loginButtonHeight),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackSideInset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.stackSideInset),
            stackBottomConstraint
        ])
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        stackBottomConstraint.constant = -(frame.height + Constants.keyboardBottomPadding)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}


// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    func setLoading(_ loading: Bool) {
        loginButton.isEnabled = !loading
    }
    
    func showError(_ message: String) {
        errorAlert(message)
    }
}


private extension LoginViewController {
    enum Constants {
        static let loginImageTopInset: CGFloat = 13
        static let loginImageSideInset: CGFloat = 44
        static let stackSideInset: CGFloat = 25
        static let stackBottomInitial: CGFloat = -133
        static let loginButtonHeight: CGFloat = 55
        static let loginButtonCornerRadius: CGFloat = loginButtonHeight / 2
        static let loginButtonShadowOffset = CGSize(width: 0, height: 20)
        static let loginButtonShadowRadius: CGFloat = 15 // blur 30 / 2
        static let loginButtonShadowColorAlpha: Float = 0.1
        static let keyboardBottomPadding: CGFloat = 10
    }
    
    enum Strings {
        static let usernamePlaceholder = "Username"
        static let passwordPlaceholder = "Password"
        static let loginButtonTitle = "Login"
        static let cancel = "Отменить"
        static let retry = "Повторить"
    }
}

#if DEBUG
#Preview {
    LoginModuleFactory.make()
}
#endif
