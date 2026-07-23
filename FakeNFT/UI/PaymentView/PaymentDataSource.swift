//
//  PaymentDataSource.swift
//  FakeNFT
//
//  Created by Сергей Петров on 22.07.2026.
//

import UIKit

enum PaymentSection: Hashable {
    case main
}

final class PaymentDataSource: UICollectionViewDiffableDataSource<PaymentSection, Currency> {
    
    typealias CellConfigurationHandler = (UICollectionView, IndexPath, Currency) -> PaymentCurrencyCollectionViewCell?
    
    private let cellConfiguration: CellConfigurationHandler
    
    init(collectionView: UICollectionView, cellConfiguration: @escaping CellConfigurationHandler) {
        self.cellConfiguration = cellConfiguration
        
        super.init(collectionView: collectionView) { collectionView, indexPath, currency in
            return cellConfiguration(collectionView, indexPath, currency)
        }
    }
}
