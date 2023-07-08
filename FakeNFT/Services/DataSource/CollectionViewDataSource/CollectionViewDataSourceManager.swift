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
    typealias CollectionDataSource = UICollectionViewDiffableDataSource<PaymentMethodSection, VisibleSingleNfts>
    typealias CollectionSnapshot = NSDiffableDataSourceSnapshot<PaymentMethodSection, VisibleSingleNfts>
    var onCartHandler: ((String?) -> Void)? { get set }
    var onLikeHandler: ((String?) -> Void)? { get set }
    func createDataSource(with collectionView: UICollectionView, with data: [VisibleSingleNfts])
    func updateCollection(with data: [VisibleSingleNfts])
}

final class CollectionViewDataSourceManager {
    private var cartDataSource: CartDataSource?
    private var collectionDataSource: CollectionDataSource?
    var onCartHandler: ((String?) -> Void)?
    var onLikeHandler: ((String?) -> Void)?
}

// MARK: - Ext NftCollectionDSManagerProtocol
extension CollectionViewDataSourceManager: NftCollectionDSManagerProtocol {
    func createDataSource(with collectionView: UICollectionView, with data: [VisibleSingleNfts]) {
        collectionDataSource = CollectionDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            return self?.catalogCollectionCell(collectionView: collectionView, indexPath: indexPath, item: itemIdentifier)
        })
    }
    
    func updateCollection(with data: [VisibleSingleNfts]) {
        collectionDataSource?.apply(createCatalogSingleCollectionSnapshot(from: data), animatingDifferences: true, completion: nil)
    }
    
    private func catalogCollectionCell(collectionView: UICollectionView, indexPath: IndexPath, item: VisibleSingleNfts) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: CatalogCollectionViewCell.defaultReuseIdentifier,
                for: indexPath) as? CatalogCollectionViewCell
        else { return UICollectionViewCell(frame: .zero) }
        cell.viewModel = CatalogCollectionCellViewModel(nftRow: item)
        cell.onCart = { [weak self] id in
            self?.onCartHandler?(id)
        }
        cell.onLike = { [weak self] id in
            self?.onLikeHandler?(id)
        }
        return cell
    }
    
    private func createCatalogSingleCollectionSnapshot(from data: [VisibleSingleNfts]) -> CollectionSnapshot {
        var snapshot = CollectionSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
}

// MARK: - Ext PaymentMethodDSManagerProtocol
extension CollectionViewDataSourceManager: PaymentMethodDSManagerProtocol {
    func createDataSource(with collectionView: UICollectionView, with data: [PaymentMethodRow]) {
        cartDataSource = CartDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            return self?.cartPaymentMethodCell(collectionView: collectionView, indexPath: indexPath, item: itemIdentifier)
        })
        cartDataSource?.apply(createCartPaymentMethodSnapshot(from: data))
    }
    
    func updateCollection(with data: [PaymentMethodRow]) {
        cartDataSource?.apply(createCartPaymentMethodSnapshot(from: data), animatingDifferences: true)
    }
    
    private func cartPaymentMethodCell(collectionView: UICollectionView, indexPath: IndexPath, item: PaymentMethodRow) -> UICollectionViewCell {
        guard
            let cell = collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: CartPaymentMethodCell.defaultReuseIdentifier,
                    for: indexPath) as? CartPaymentMethodCell
        else { return UICollectionViewCell(frame: .zero) }
        cell.viewModel = PaymentMethodCellViewModel(paymentMethodRow: item)
        return cell
    }
    
    private func createCartPaymentMethodSnapshot(from data: [PaymentMethodRow]) -> CartSnapshot {
        var snapshot = CartSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
}
