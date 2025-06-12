//
//  CoinInfoTVCell.swift
//  Wallet
//
//  Created by Yuriy on 11.06.2025.
//

import UIKit

final class CoinInfoTVCell: UITableViewCell {
    static let id = String(describing: CoinInfoTVCell.self)
    
    // MARK: - UI
    
    private let coinPrice: UILabel = {
        $0.textAlignment = .center
        $0.font = .poppins(weight: .medium, size: 28)
        $0.textColor = .color191C32
        return $0
    }(UILabel())
    
    private let coinChangeLabel: UILabel = {
        $0.font = .poppins(weight: .medium, size: 14)
        $0.textColor = .color9395A4
        return $0
    }(UILabel())

    private let coinImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var horizontalStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [coinChangeLabel]))
    
    private lazy var verticalStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .center
        return $0
    }(UIStackView(arrangedSubviews: [coinPrice, horizontalStackView]))
    
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout

    private func setupView() {
        selectionStyle = .none
        contentView.backgroundColor = .none
        backgroundColor = .colorF3F5F6
        contentView.addSubview(verticalStackView)
        contentView.turnoffTAMIC()
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    //MARK: - Public
    func config(price: String, change: String, image: UIImage?) {
        coinPrice.text = price
        coinChangeLabel.text = change
        if let image {
            horizontalStackView.insertArrangedSubview(coinImageView, at: 0)
            coinImageView.image = image
        }
    }
}

