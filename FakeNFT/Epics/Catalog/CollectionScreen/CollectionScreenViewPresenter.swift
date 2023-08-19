//
//  CollectionScreenViewPresenter.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import Foundation

final class CollectionScreenViewPresenter: CollectionScreenViewPresenterProtocol {
    var actualNftsCount: Int {
        nfts.count
    }
    var collectionName: String {
        catalogDataModel.name
    }
    var collectionCover: URL? {
        takeURL(link: catalogDataModel.cover)
    }
    var collectionDescription: String {
        catalogDataModel.description
    }
    var initialNftCount: Int {
        catalogDataModel.nfts.count
    }
    lazy var webViewScreen: WebViewScreenViewController = {
        let presenter = WebViewScreenViewPresenter()
        let webViewScreen = WebViewScreenViewController(presenter: presenter)
        presenter.injectViewController(webViewViewController: webViewScreen)
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
    
    func injectViewController(viewController: CollectionScreenViewControllerProtocol) {
        collectionScreenViewController = viewController
    }
    
    func viewMadeFetchRequest() {
        authorNetworkService.fetchAuthor(id: catalogDataModel.author)
        nftNetworkService.fetchNft(id: catalogDataModel.author)
    }
    
    func viewDidRequestNftFromNfts(index: Int) -> NftModel {
        nfts[index]
    }
    
    func takeURL(link: String) -> URL? {
        URL(string: link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
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
