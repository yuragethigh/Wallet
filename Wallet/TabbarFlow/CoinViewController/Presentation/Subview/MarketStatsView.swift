//
//  MarketStatsView.swift
//  Wallet
//
//  Created by Yuriy on 12.06.2025.
//

import UIKit

extension MarketStatsView {
    struct MarketStatItem {
        let title: String
        let value: String
    }
}


final class MarketStatsView: UIView {
    
    // MARK: - UI

    private let titleLabel: UILabel = {
        $0.textAlignment = .left
        $0.font = .poppins(weight: .medium, size: 20)
        $0.textColor = .color191C32
        $0.text = "Market Statistic"
        return $0
    }(UILabel())

    private let stackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView())
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 28
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        addSubview(stackView)
        
        turnoffTAMIC()
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    
    func configure(with items: [MarketStatItem]) {
        stackView.addArrangedSubview(titleLabel)
        items.forEach {
            let row = MarketStatRowView()
            row.setup(title: $0.title, value: $0.value)
            stackView.addArrangedSubview(row)
        }
    }
}


final class MarketStatRowView: UIView {
    
    // MARK: - UI

    private let titleLabel: UILabel = {
        $0.textColor = .color9395A4
        $0.font = .poppins(weight: .medium, size: 14)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private let valueLabel: UILabel = {
        $0.textColor = .color191C32
        $0.font = .poppins(weight: .semibold, size: 14)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    private lazy var stack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel, valueLabel]))
    
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup UI

    private func setupView() {
        addSubview(stack)
        turnoffTAMIC()
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    //MARK: - Public
    func setup(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}

