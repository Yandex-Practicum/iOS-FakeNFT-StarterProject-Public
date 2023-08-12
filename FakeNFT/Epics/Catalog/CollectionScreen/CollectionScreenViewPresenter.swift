//
//  CollectionScreenViewPresenter.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import UIKit

final class CollectionScreenViewPresenter: CollectionScreenViewPresenterProtocol {
    weak var collectionScreenViewController: CollectionScreenViewControllerProtocol?
    private var dataModel: CatalogDataModel
    private var nfts: [NftModel] = []
    let collectionScreenNetworkService = NftNetworkService.shared
    let authorNetworkService = AuthorNetworkService.shared
    private var collectionAuthorNetworkServiceObserver: NSObjectProtocol?
    private var collectionNftNetworkServiceObserver: NSObjectProtocol?
    
    init(dataModel: CatalogDataModel) {
        self.dataModel = dataModel
        collectionAuthorNetworkServiceObserver = NotificationCenter.default
            .addObserver(
                forName: AuthorNetworkService.authorNetworkServiceDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.collectionScreenViewController?.updateAuthor()
            }
        collectionNftNetworkServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftNetworkService.nftNetworkServiceDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateCollection()
            }
    }
    
    func makeFetchRequest() {
        authorNetworkService.fetchAuthor(id: dataModel.author)
        collectionScreenNetworkService.fetchNft(id: dataModel.author)
    }
    
    private func updateCollection() {
        let oldCount = nfts.count
        let newCount = collectionScreenNetworkService.nfts.count
        nfts = collectionScreenNetworkService.nfts.sorted(by: { $0.rating > $1.rating })
        if oldCount != newCount {
            collectionScreenViewController?.updateCollection(oldCount: oldCount, newCount: newCount)
        }
        collectionScreenViewController?.viewReadinessCheck()
    }
    
    func takeInitialNftCount() -> Int {
        dataModel.nfts.count
    }
    
    func takeNftCount() -> Int {
        nfts.count
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
    
    func takeNftCoverLink() -> String? {
        dataModel.cover.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
    
    func takeNftName() -> String {
        dataModel.name
    }
    
    func takeNftDescription() -> String {
        dataModel.description
    }
}
