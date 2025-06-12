//
//  SwitcherTVCell.swift
//  Wallet
//
//  Created by Yuriy on 11.06.2025.
//

import UIKit

//MARK: - SwitcherTVCell -> VC
protocol SwitcherTVCellDelegate: AnyObject {
    func didSelectTime(_ time: SwitcherTVCell.Time)
}

final class SwitcherTVCell: UITableViewCell {
    static let id = String(describing: SwitcherTVCell.self)
    
    enum Time: String, CaseIterable {
        case h24 = "24H"
        case w1 = "1W"
        case y1 = "1Y"
        case all = "ALL"
        case point = "Point"
    }
    
    private let filters = Time.allCases
    private var selectedTime: Time = .h24
    weak var delegate: SwitcherTVCellDelegate?
    
    //MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = IntrinsicCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .colorEBEFF1
        cv.layer.cornerRadius = 28
        cv.register(SwitcherSegmentCell.self, forCellWithReuseIdentifier: SwitcherSegmentCell.id)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .none
        backgroundColor = .colorF3F5F6
        contentView.addSubview(collectionView)
        contentView.turnoffTAMIC()
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public
    func configure(initialTime: Time = .h24) {
        selectedTime = initialTime
        collectionView.reloadData()
        if let index = filters.firstIndex(of: selectedTime) {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension SwitcherTVCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let time = filters[indexPath.item]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SwitcherSegmentCell.id, for: indexPath
        ) as! SwitcherSegmentCell
        cell.configure(with: time.rawValue)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let time = filters[indexPath.item]
        selectedTime = time
        delegate?.didSelectTime(time)
    }
}


// MARK: - SwitcherSegmentCell
final class SwitcherSegmentCell: UICollectionViewCell {
    static let id = String(describing: SwitcherSegmentCell.self)

    //MARK: - UI
    private let titleLabel: UILabel = {
        $0.textColor = .color9395A5
        $0.font = .poppins(weight: .medium, size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel())

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .white.withAlphaComponent(0.8) : .clear
            titleLabel.textColor = isSelected ? .color191C32 : .color9395A5
            titleLabel.font = isSelected ? .poppins(weight: .semibold, size: 14) :
                .poppins(weight: .medium, size: 14)
        }
    }
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 24
        contentView.addSubview(titleLabel)
        contentView.turnoffTAMIC()
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Public

    func configure(with title: String) {
        titleLabel.text = title
    }
}



#if DEBUG
#Preview {
    CoinViewControllerFactory.make(model: .init(id: "", name: "Bitcoin", symbol: "BTC", price: 11111111.23, change24h: 23))
}
#endif
