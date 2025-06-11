//
//  NavigationbarModalView.swift
//  Wallet
//
//  Created by Yuriy on 10.06.2025.
//

import UIKit

protocol ModalMenuViewDelegate: AnyObject {
    func modalMenu(_ menu: ModalMenuView, didSelect item: ModalMenuItem)
}

protocol ModalMenuItem {
    var title: String   { get }
    var image: UIImage? { get }
}

final class ModalMenuView: UIView {

    // MARK: - Public
    
    func present() {
        guard !isShow else { return }
        
        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: -20)
        
        UIView.animate(
            withDuration: 0.30,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.6,
            options: [.curveEaseOut]
        ) {
            self.alpha     = 1
            self.transform = .identity
        }
        
        isShow = true
    }

    func dismiss() {
        guard isShow else { return }
        
        UIView.animate(
            withDuration: 0.20,
            delay: 0,
            options: [.curveEaseIn]
        ) {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: -20)
        } completion: { _ in
            self.transform = .identity
            self.isShow   = false
        }
    }

    var isShow = false
    weak var delegate: ModalMenuViewDelegate?

    func configure<T: ModalMenuItem>(items: [T]) {
        self.items = items
    }

    //MARK: - Private
    private var items: [ModalMenuItem] = []

    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flow)
        cv.backgroundColor   = .white
        cv.layer.cornerRadius = 16
        cv.contentInset = .init(top: 16, left: 20, bottom: 16, right: 20)
        cv.dataSource   = self
        cv.delegate     = self
        cv.register(ModalViewCell.self,
                    forCellWithReuseIdentifier: ModalViewCell.id)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 0
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override var intrinsicContentSize: CGSize {

        let font       = UIFont.poppins(weight: .medium, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
        let longest    = items.map(\.title).max(by: { $0.count < $1.count })
        let textWidth  = (longest as? NSString)?.size(withAttributes: [.font: font]).width

        let rowWidth = 24 + 8 + ceil(textWidth ?? 0)
        let width    = rowWidth + collectionView.contentInset.left + collectionView.contentInset.right

        let rows      = CGFloat(items.count)
        let height    = rows * 27
                       + (rows - 1) * 16
                       + collectionView.contentInset.top
                       + collectionView.contentInset.bottom

        return CGSize(width: width, height: height)
    }
}


extension ModalMenuView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ cv: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: ModalViewCell.id,
                                          for: indexPath) as! ModalViewCell
        cell.config(items[indexPath.item])
        return cell
    }
    func collectionView(_ cv: UICollectionView,
                        layout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = cv.bounds.width - cv.contentInset.left - cv.contentInset.right
        return CGSize(width: w, height: 27)
    }

    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.modalMenu(self, didSelect: items[indexPath.item])
    }
}

final class ModalViewCell: UICollectionViewCell {
    static let id = String(describing: ModalViewCell.self)
    
    // MARK: - UI
    
    private let imageViewCell: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.setContentHuggingPriority(.required, for: .horizontal)
        return $0
    }(UIImageView())
    
    private let labelCell: UILabel = {
        $0.font = .poppins(weight: .medium, size: 18)
        $0.textColor = .color26273C
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var stack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        return $0
    }(UIStackView(arrangedSubviews: [labelCell]))
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    
    private func setupView() {
        contentView.addSubview(stack)
        contentView.turnoffTAMIC()

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    //MARK: - Public
    
    func config(_ model: ModalMenuItem) {
        if let image = model.image {
            stack.insertArrangedSubview(imageViewCell, at: 0)
            imageViewCell.image = image
            labelCell.text = model.title
        } else {
            labelCell.text = model.title
        }
    }
}


enum NavbarMenuItem: CaseIterable, ModalMenuItem {
    case reload, logout

    var title: String {
        switch self {
        case .reload: "Обновить"
        case .logout: "Выйти"
        }
    }
    var image: UIImage? {
        switch self {
        case .reload: .reload
        case .logout: .logout
        }
    }
}

enum SortMenuItem: CaseIterable, ModalMenuItem {
    case none, up24, down24

    var title: String {
        switch self {
        case .none: "Без сортировки"
        case .up24: "Возрастание"
        case .down24: "Убывание"
        }
    }
    var image: UIImage? {
        switch self {
        case .none: .reload
        case .up24: .reload
        case .down24: .reload
        }
    }
}
