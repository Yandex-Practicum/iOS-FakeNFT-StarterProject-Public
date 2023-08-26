//
//  NSCollectionLayoutGroup.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 05.08.2023.
//

import UIKit

extension NSCollectionLayoutGroup {
    static func create(horizontalGroupWithWidth width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, items: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup {
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: width,
                heightDimension: height),
            subitems: items
        )

        return group
    }

    static func create(verticalGroupWithWidth width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, items: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup {
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: width,
                heightDimension: height),
            subitems: items
        )

        return group
    }
}
