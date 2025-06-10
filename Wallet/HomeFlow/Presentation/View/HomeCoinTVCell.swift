//
//  HomeCoinTVCell.swift
//  Wallet
//
//  Created by Yuriy on 09.06.2025.
//

import UIKit

final class HomeCoinTVCell: UITableViewCell {
    
    static let id = String(describing: HomeCoinTVCell.self)
    
    // MARK: - UI
    
    private let spinner: UIActivityIndicatorView = {
        $0.style = .medium
        $0.hidesWhenStopped = true
        return $0
    }(UIActivityIndicatorView())

    private let imageViewCoin: UIImageView = {
        $0.image = .bitcoin
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let nameLabel: UILabel = {
        $0.font = .poppins(weight: .medium, size: 18)
        $0.textColor = .color26273C
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private let symbolLabel: UILabel = {
        $0.font = .poppins(weight: .medium, size: 14)
        $0.textColor = .color9395A4
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var nameSymbolStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 3
        $0.alignment = .leading
        $0.distribution = .fill
        return $0
    }(UIStackView(arrangedSubviews: [nameLabel, symbolLabel]))
    
    private let priceLabel: UILabel = {
        $0.font = .poppins(weight: .medium, size: 18)
        $0.textColor = .color26273C
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private let changeLabel: UILabel = {
        $0.font = .poppins(weight: .medium, size: 14)
        $0.textColor = .color9395A4
        $0.textAlignment = .right
        return $0
    }(UILabel())

    private let imageViewArrow: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var imageChangeLabelStack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .center
        $0.distribution = .fill
        return $0
    }(UIStackView(arrangedSubviews: [imageViewArrow, changeLabel]))
    
    private lazy var priceImageChangeLabelStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 3
        return $0
    }(UIStackView(arrangedSubviews: [priceLabel, imageChangeLabelStack]))
    
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewCoin.isHidden = true
        nameLabel.text = nil
        symbolLabel.text = nil
        priceLabel.text = nil
        imageViewArrow.image = nil
        changeLabel.text = nil
    }
    
    // MARK: - Layout
    
    private func setupView() {
        selectionStyle = .none
        contentView.backgroundColor = .none
        backgroundColor = .colorF7F7FA
        contentView.addSubview(imageViewCoin)
        contentView.addSubview(nameSymbolStack)
        contentView.addSubview(priceImageChangeLabelStack)
        contentView.addSubview(spinner)

        
        contentView.turnoffTAMIC()
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 70),
            spinner.topAnchor.constraint(equalTo: contentView.topAnchor),
            spinner.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            spinner.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spinner.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            imageViewCoin.heightAnchor.constraint(equalToConstant: 50),
            imageViewCoin.widthAnchor.constraint(equalToConstant: 50),
            imageViewCoin.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            imageViewCoin.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameSymbolStack.leadingAnchor.constraint(equalTo: imageViewCoin.trailingAnchor, constant: 19),
            nameSymbolStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            priceImageChangeLabelStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            priceImageChangeLabelStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        layoutIfNeeded()
    }
    
    //MARK: - Public methods
    
    func congigure(coin: HomeModel.Coin?) {
        if let coin {
            spinner.stopAnimating()
            imageViewCoin.isHidden = false
            nameLabel.text = coin.name
            symbolLabel.text = coin.symbol
            priceLabel.text = coin.price
            imageViewArrow.image = coin.icon
            changeLabel.text = coin.change
        } else {
            spinner.startAnimating()
        }
    }

    //MARK: - Privete methods

}
