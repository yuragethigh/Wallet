//
//  SwitcherTVCell.swift
//  Wallet
//
//  Created by Yuriy on 11.06.2025.
//

import UIKit

final class SwitcherTVCell: UITableViewCell {
    static let id = String(describing: SwitcherTVCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

