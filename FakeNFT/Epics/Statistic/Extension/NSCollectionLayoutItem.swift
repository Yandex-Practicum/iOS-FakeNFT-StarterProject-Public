//
//  CollectionView.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 05.08.2023.
//

import UIKit

extension NSCollectionLayoutItem {
    static func create(withWidth width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, insets: NSDirectionalEdgeInsets) -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: width,
                heightDimension: height)
        )
        item.contentInsets = insets
        return item
    }
}
