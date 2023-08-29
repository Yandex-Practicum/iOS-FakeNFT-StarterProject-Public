//
//  NFTScreenVC+UICollectionViewDelegate.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

extension NFTScreenVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return gridGeometric.cellSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: 4,
            left: gridGeometric.leftInset,
            bottom: 4,
            right: gridGeometric.rightInset
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - gridGeometric.paddingWidth
        let cellWidth =  availableWidth / CGFloat(gridGeometric.cellCount)
        let cellHeight = cellWidth * 1.77
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
