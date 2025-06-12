//
//  LoginViewTextField.swift
//  Wallet
//
//  Created by Yuriy on 05.06.2025.
//

import UIKit

final class LoginViewTextField: UIView {

    // MARK: - UI
    
    let iconImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.setContentHuggingPriority(.required, for: .horizontal)
        return $0
    }(UIImageView())

    let textField: TextField = {
        $0.font = .poppins(weight: .regular, size: 15)
        return $0
    }(TextField())

    private lazy var horizontalStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = Constants.spacing
        $0.alignment = .center
        $0.distribution = .fill
        $0.backgroundColor = Constants.stackBGColor
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.layoutMargins = UIEdgeInsets(
            top: 0, left: Constants.inset, bottom: 0, right: Constants.inset
        )
        $0.isLayoutMarginsRelativeArrangement = true
        return $0
    }(UIStackView(arrangedSubviews: [iconImageView, textField]))

    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods

    private func setupView() {
        addSubview(horizontalStackView)
        turnoffTAMIC()

        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            horizontalStackView.heightAnchor.constraint(equalToConstant: Constants.height)
        ])
    }
    
    //MARK: - Constants
    
    private enum Constants {
        static let height: CGFloat = 55
        static let spacing: CGFloat = 20
        static let inset: CGFloat = 10
        static let cornerRadius: CGFloat = 25
        static let stackBGColor: UIColor = .white.withAlphaComponent(0.8)
    }
}


#if DEBUG
#Preview {
    LoginModuleFactory.make()
}
#endif
