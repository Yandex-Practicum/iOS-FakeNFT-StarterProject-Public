//
//  CollectionViewDataSourceManager.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 09.07.2023.
//

import UIKit

protocol GenericDataSourceManagerProtocol {
    func createDataSource(with collectionView: UICollectionView, with data: [AnyHashable])
    func updateCollection(with data: [AnyHashable])
}

protocol CollectionViewDataSourceCoordinatable {
    var onCartHandler: ((String?) -> Void)? { get set }
    var onLikeHandler: ((String?) -> Void)? { get set }
}

// MARK: - Final class
final class CollectionViewDataSourceManager<T: Hashable>: CollectionViewDataSourceCoordinatable {
    typealias DataSource = UICollectionViewDiffableDataSource<CollectionDiffableDataSourceSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<CollectionDiffableDataSourceSection, AnyHashable>
    
    private var genericDataSource: DataSource?
    
    var onCartHandler: ((String?) -> Void)?
    var onLikeHandler: ((String?) -> Void)?
    
}

// MARK: - Ext GenericDataSourceManagerProtocol
extension CollectionViewDataSourceManager: GenericDataSourceManagerProtocol {
    func createDataSource(with collectionView: UICollectionView, with data: [AnyHashable]) {
        genericDataSource = UICollectionViewDiffableDataSource<CollectionDiffableDataSourceSection, AnyHashable>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            return self?.collectionViewCell(collectionView: collectionView, indexPath: indexPath, item: itemIdentifier)
        })
    }
    
    func updateCollection(with data: [AnyHashable]) {
        genericDataSource?.apply(createGenericSnapshot(from: data), animatingDifferences: true, completion: nil)
    }
}

// MARK: - Ext Private
private extension CollectionViewDataSourceManager {
    func collectionViewCell(collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell {
        switch item.base {
        case let paymentMethodRow as PaymentMethodRow:
            return setupCartPaymentMethodCell(collectionView, at: indexPath, with: paymentMethodRow)
        case let visibleSingleNfts as VisibleSingleNfts:
            return setupCatalogCollectionViewCell(collectionView, at: indexPath, with: visibleSingleNfts)
        default:
            return UICollectionViewCell(frame: .zero)
        }
    }
    
    func setupCartPaymentMethodCell(_ collectionView: UICollectionView, at indexPath: IndexPath, with row: PaymentMethodRow) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CartPaymentMethodCell.defaultReuseIdentifier,
                for: indexPath) as? CartPaymentMethodCell
        else {
            return UICollectionViewCell(frame: .zero)
        }
        
        cell.viewModel = PaymentMethodCellViewModel(paymentMethodRow: row)
        
        return cell
    }
    
    func setupCatalogCollectionViewCell(_ collectionView: UICollectionView, at indexPath: IndexPath, with row: VisibleSingleNfts) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CatalogCollectionViewCell.defaultReuseIdentifier,
                for: indexPath) as? CatalogCollectionViewCell
        else {
            return UICollectionViewCell(frame: .zero)
        }
        
        cell.viewModel = CatalogCollectionCellViewModel(nftRow: row)
        
        cell.onCart = { [weak self] id in
            self?.onCartHandler?(id)
        }
        
        cell.onLike = { [weak self] id in
            self?.onLikeHandler?(id)
        }
        
        return cell
    }
    
    func createGenericSnapshot(from data: [AnyHashable]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
}
