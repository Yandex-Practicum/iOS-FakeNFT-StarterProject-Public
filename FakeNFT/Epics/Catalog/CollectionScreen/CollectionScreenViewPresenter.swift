//
//  CollectionScreenViewPresenter.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import UIKit

final class CollectionScreenViewPresenter: CollectionScreenViewPresenterProtocol {
    weak var collectionScreenViewController: CollectionScreenViewControllerProtocol?
    private var catalogDataModel: CatalogDataModel
    private var nfts: [NftModel] = []
    private let nftNetworkService = NftNetworkService.shared
    private let authorNetworkService = AuthorNetworkService.shared
    private var authorNetworkServiceObserver: NSObjectProtocol?
    private var nftNetworkServiceObserver: NSObjectProtocol?
    
    init(catalogDataModel: CatalogDataModel) {
        self.catalogDataModel = catalogDataModel
        authorNetworkServiceObserver = NotificationCenter.default
            .addObserver(
                forName: AuthorNetworkService.authorNetworkServiceDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.collectionScreenViewController?.updateAuthor()
            }
        nftNetworkServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftNetworkService.nftNetworkServiceDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateCollection()
            }
    }
    
    func makeFetchRequest() {
        authorNetworkService.fetchAuthor(id: catalogDataModel.author)
        nftNetworkService.fetchNft(id: catalogDataModel.author)
    }
        
    func configureCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionScreenCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let nft = nfts[indexPath.row]
        cell.setNftImage(link: nft.images.first ?? "")
        cell.setRating(rate: nft.rating)
        cell.setNameLabel(name: nft.name)
        cell.setCostLabel(cost: nft.price)
        return cell
    }
    
    func takeInitialNftCount() -> Int {
        catalogDataModel.nfts.count
    }
    
    func takeActualNftCount() -> Int {
        nfts.count
    }
    
    func takeNftCoverLink() -> String? {
        catalogDataModel.cover.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
    
    func takeNftName() -> String {
        catalogDataModel.name
    }
    
    func takeNftDescription() -> String {
        catalogDataModel.description
    }
    
    private func updateCollection() {
        let oldCount = nfts.count
        let newCount = nftNetworkService.nfts.count
        nfts = nftNetworkService.nfts.sorted(by: { $0.rating > $1.rating })
        if oldCount != newCount {
            collectionScreenViewController?.updateCollection(oldCount: oldCount, newCount: newCount)
        }
        collectionScreenViewController?.viewReadinessCheck()
    }
}
