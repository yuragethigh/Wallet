//
//  IntrinsicCollectionView.swift
//  Wallet
//
//  Created by Yuriy on 12.06.2025.
//

import UIKit

final class IntrinsicCollectionView: UICollectionView {
    override var intrinsicContentSize: CGSize {
        self.collectionViewLayout.collectionViewContentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}

