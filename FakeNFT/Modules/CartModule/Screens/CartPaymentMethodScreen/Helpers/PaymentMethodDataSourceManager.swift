//
//  PaymentMethodDataSourceManager.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 23.06.2023.
//

import UIKit

protocol PaymentMethodDSManagerProtocol {
    func createDataSource(with collectionView: UICollectionView, with data: [PaymentMethodRow])
    func updateCollection(with data: [PaymentMethodRow])
}

final class PaymentMethodDataSourceManager: PaymentMethodDSManagerProtocol {
    
    typealias DataSource = UICollectionViewDiffableDataSource<PaymentMethodSection, PaymentMethodRow>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PaymentMethodSection, PaymentMethodRow>
    
    private var dataSource: DataSource?
    
    func createDataSource(with collectionView: UICollectionView, with data: [PaymentMethodRow]) {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            return self?.cell(collectionView: collectionView, indexPath: indexPath, item: itemIdentifier)
        })
        dataSource?.apply(createSnapshot(from: data))
    }
    
    func updateCollection(with data: [PaymentMethodRow]) {
        dataSource?.apply(createSnapshot(from: data), animatingDifferences: true)
    }
}

private extension PaymentMethodDataSourceManager {
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
    
    func createSnapshot(from data: [PaymentMethodRow]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
}
