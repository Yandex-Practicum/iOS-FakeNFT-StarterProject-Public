//
//  CollectionScreenViewPresenter.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import UIKit

final class CollectionScreenViewPresenter: CollectionScreenViewPresenterProtocol {
    var actualNftsCount: Int {
        nfts.count
    }
    var takeCollectionName: String {
        catalogDataModel.name
    }
    var takeCollectionCover: String {
        catalogDataModel.cover
    }
    var takeCollectionDescription: String {
        catalogDataModel.description
    }
    var takeInitialNftCount: Int {
        catalogDataModel.nfts.count
    }
    lazy var createWebViewScreen: WebViewScreenViewController = {
        let webViewScreen = WebViewScreenViewController()
        webViewScreen.modalPresentationStyle = .fullScreen
        return webViewScreen
    }()
    
    weak private var collectionScreenViewController: CollectionScreenViewControllerProtocol?
    private var nfts: [NftModel] = []
    private var catalogDataModel: CatalogDataModel
    private let nftNetworkService = NftNetworkService.shared
    private let authorNetworkService = AuthorNetworkService.shared
    private var authorNetworkServiceObserver: NSObjectProtocol?
    private var nftNetworkServiceObserver: NSObjectProtocol?
    
    init(viewController: CollectionScreenViewControllerProtocol, catalogDataModel: CatalogDataModel) {
        collectionScreenViewController = viewController
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
    
    func takeNftFromNfts(index: Int) -> NftModel {
        nfts[index]
    }
    
    private func updateCollection() {
        let oldCount = nfts.count
        let newCount = nftNetworkService.nfts.count
        nfts = nftNetworkService.nfts.sorted(by: ) { $0.rating > $1.rating }
        if oldCount != newCount {
            collectionScreenViewController?.updateCollection(oldCount: 0, newCount: newCount)
        }
        collectionScreenViewController?.viewReadinessCheck()
    }
}
