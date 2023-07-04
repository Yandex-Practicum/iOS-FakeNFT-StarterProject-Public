//
//  CollectionViewDataSourceManager.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 23.06.2023.
//

import UIKit

protocol PaymentMethodDSManagerProtocol {
    typealias CartDataSource = UICollectionViewDiffableDataSource<PaymentMethodSection, PaymentMethodRow>
    typealias CartSnapshot = NSDiffableDataSourceSnapshot<PaymentMethodSection, PaymentMethodRow>
    func createDataSource(with collectionView: UICollectionView, with data: [PaymentMethodRow])
    func updateCollection(with data: [PaymentMethodRow])
}

protocol NftCollectionDSManagerProtocol {
    typealias CollectionDataSource = UICollectionViewDiffableDataSource<PaymentMethodSection, PaymentMethodRow>
    typealias CollectionSnapshot = NSDiffableDataSourceSnapshot<PaymentMethodSection, PaymentMethodRow>
    func createDataSource(with collectionView: UICollectionView, with data: NftCollection)
    func updateCollection(with data: NftCollection)
}

final class CollectionViewDataSourceManager: PaymentMethodDSManagerProtocol {
    private var dataSource: CartDataSource?
    
    func createDataSource(with collectionView: UICollectionView, with data: [PaymentMethodRow]) {
        dataSource = CartDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            return self?.cell(collectionView: collectionView, indexPath: indexPath, item: itemIdentifier)
        })
        dataSource?.apply(createSnapshot(from: data))
    }
    
    func updateCollection(with data: [PaymentMethodRow]) {
        dataSource?.apply(createSnapshot(from: data), animatingDifferences: true)
    }
}

// MARK: - Ext NftCollectionDSManagerProtocol
extension CollectionViewDataSourceManager: NftCollectionDSManagerProtocol {
    func createDataSource(with collectionView: UICollectionView, with data: NftCollection) {
        
    }
    
    func updateCollection(with data: NftCollection) {
        
    }
}

// MARK: - Ext
private extension CollectionViewDataSourceManager {
    func cell(collectionView: UICollectionView, indexPath: IndexPath, item: PaymentMethodRow) -> UICollectionViewCell {
        guard
            let cell = collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: CartPaymentMethodCell.defaultReuseIdentifier,
                    for: indexPath) as? CartPaymentMethodCell
        else { return UICollectionViewCell(frame: .zero) }
        cell.viewModel = PaymentMethodCellViewModel(paymentMethodRow: item)
        return cell
    }
    
    func createSnapshot(from data: [PaymentMethodRow]) -> CartSnapshot {
        var snapshot = CartSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
}
