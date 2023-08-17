//
//  CollectionScreenViewPresenter.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import UIKit

final class CollectionScreenViewPresenter: CollectionScreenViewPresenterProtocol {
    weak var collectionScreenViewController: CollectionScreenViewControllerProtocol?
    var catalogDataModel: CatalogDataModel
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
    
    func takeNfts() -> [NftModel] {
        nfts
    }
    
    func makeFetchRequest() {
        authorNetworkService.fetchAuthor(id: catalogDataModel.author)
        nftNetworkService.fetchNft(id: catalogDataModel.author)
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
    
    func createWebViewScreen() -> WebViewScreenViewController {
        let webViewScreen = WebViewScreenViewController()
        let presenter = WebViewScreenViewPresenter(authorWebSiteLink: authorNetworkService.author?.website.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
        webViewScreen.presenter = presenter
        presenter.viewController = webViewScreen
        webViewScreen.modalPresentationStyle = .fullScreen
        return webViewScreen
    }
    
    private func updateCollection() {
        let oldCount = nfts.count
        let newCount = nftNetworkService.nfts.count
        nfts = nftNetworkService.nfts.sorted(by: { $0.rating > $1.rating })
        if oldCount != newCount {
            collectionScreenViewController?.updateCollection(oldCount: 0, newCount: newCount)
        }
        collectionScreenViewController?.viewReadinessCheck()
    }
}
