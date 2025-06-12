//
//  HomeHeaderTVCell.swift
//  Wallet
//
//  Created by Yuriy on 09.06.2025.
//

import UIKit

final class HomeHeaderTVCell: UITableViewCell {
    
    static let id = String(describing: HomeHeaderTVCell.self)
    
    // MARK: - UI
    private let headerImageView: UIImageView = {
        $0.image = .homeHeader
        $0.contentMode = .scaleToFill
        return $0
    }(UIImageView())
    
    private lazy var bottomHeaderImageViewConstraint: NSLayoutConstraint = {
        headerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    }()

    private let trendingLabel: UILabel = {
        $0.text = Strings.trending
        $0.font = .poppins(weight: .medium, size: 20)
        $0.textColor = .color191C32
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var sortButton: LargeAreaButton = {
        $0.setImage(.listButton, for: .normal)
        $0.touchAreaPadding = .init(top: 10, left: 10, bottom: 10, right: 10)
        $0.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return $0
    }(LargeAreaButton())
    
    private lazy var bottomStack: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.layer.cornerRadius = Constants.bottomStackCornerRadius
        $0.layer.maskedCorners = [.layerMinXMinYCorner,
                                  .layerMaxXMinYCorner]
        $0.clipsToBounds = true
        $0.layoutMargins = Constants.bottomStackMargins
        $0.isLayoutMarginsRelativeArrangement = true
        $0.backgroundColor = .colorF7F7FA
        return $0
    }(UIStackView(arrangedSubviews: [trendingLabel, sortButton]))
    
    private let affilateLabel: UILabel = {
        $0.text = Strings.affiliateProgram
        $0.font = .poppins(weight: .medium, size: 20)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private lazy var learnMoreButton: UIButton = {
        $0.setTitle(Strings.learnMore, for: .normal)
        $0.setTitleColor(.color26273C, for: .normal)
        $0.titleLabel?.font = .poppins(weight: .semibold, size: 14)
        $0.backgroundColor = .colorFAFBFB
        $0.layer.cornerRadius = Constants.learnMoreCornerRadius
        $0.contentEdgeInsets = Constants.learnMoreInsets
        $0.addTarget(self, action: #selector(learnMoreButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
        
    private lazy var verticalStack: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 12
        return $0
    }(UIStackView(arrangedSubviews: [affilateLabel, learnMoreButton]))
    
    private lazy var bottomVerticalStackConstraint: NSLayoutConstraint = {
        verticalStack.bottomAnchor.constraint(equalTo: bottomStack.topAnchor, constant: Constants.baseGap)
    }()


    // MARK: - Initializers

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
        contentView.backgroundColor = .colorFF9AB2
        
        contentView.addSubview(headerImageView)
        contentView.addSubview(bottomStack)
        contentView.addSubview(verticalStack)
        
        contentView.turnoffTAMIC()
        
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomHeaderImageViewConstraint,
            
            bottomStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomStack.heightAnchor.constraint(equalToConstant: Constants.bottomStackHeight),
                        
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.verticalStackLeadingInset),
            bottomVerticalStackConstraint,
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

        ])
    }
    
    //MARK: - User actions
    
    @objc private func sortButtonTapped() {
        headerAction?(.sort)
    }
    
    @objc private func learnMoreButtonTapped() {
        headerAction?(.leartMore)
    }
        
    //MARK: - Public methods
    
    var headerAction: ((ActionType) -> Void)? = nil

    func stretch(for offsetY: CGFloat) {
        guard offsetY < 0 else {
            headerImageView.transform = .identity
            bottomVerticalStackConstraint.constant = Constants.baseGap
            bottomHeaderImageViewConstraint.constant = 0
            return
        }

        let delta = -offsetY * Constants.gapDamping
        headerImageView.transform = CGAffineTransform(translationX: 0, y: offsetY)
        bottomHeaderImageViewConstraint.constant = delta
        bottomVerticalStackConstraint.constant = Constants.baseGap - delta

        layoutIfNeeded()
    }
}


//MARK: - Constants

fileprivate extension HomeHeaderTVCell {
    
    private enum Constants {
        static let verticalStackLeadingInset: CGFloat = 25
        static let bottomStackHeight: CGFloat = 70
        static let baseGap: CGFloat = -55
        static let gapDamping: CGFloat = 0.6
        
        static let bottomStackCornerRadius: CGFloat = 35
        static let bottomStackMargins = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        
        static let learnMoreCornerRadius: CGFloat = 17
        static let learnMoreInsets = UIEdgeInsets(top: 7, left: 23, bottom: 7, right: 23)
    }
    
    enum Strings {
        static let trending = "Trending"
        static let affiliateProgram = "Affiliate program"
        static let learnMore = "Learn More"
    }
}


//MARK: - Actions

extension HomeHeaderTVCell {
     enum ActionType{
        case sort, leartMore
    }
}

