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
        viewWillSetImage(with: catalogDataModel.cover)
    }
    var collectionDescription: String {
        catalogDataModel.description
    }
    var authorName: String? {
        authorNetworkService.author?.name
    }
    
    weak private var viewController: CollectionScreenViewControllerProtocol?
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
                self?.viewController?.updateAuthor()
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
    
    func viewControllerInitialized(viewController: CollectionScreenViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.showHud()
        authorNetworkService.fetchAuthor(id: catalogDataModel.author)
        nftNetworkService.fetchNft(id: catalogDataModel.author)
    }
    
    func viewStartedCellConfiguration(at index: Int) -> NftModel {
        takeNftByIndex(index: index)
    }
    
    func viewWillSetImage(with link: String) -> URL? {
        URL(string: link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
    }
    
    func viewUpdatedUI(in cell: CollectionScreenMainContentCell) {
        if !cell.authorDynamicPartLabelIsEmpty
            && !cell.collectionImageIsEmpty
            && viewController?.currentNumberOfNft == catalogDataModel.nfts.count {
            viewController?.removeHud()
        }
    }
    
    func viewWillUpdateBasket(in cell: CollectionScreenNftCell, at index: Int) {
        if BasketService.shared.basket.contains(where: )({ $0.id == takeNftByIndex(index: index).id }) {
            cell.setNotEmptyBasketImage()
        }
    }
    
    func viewWillUpdateLike(in cell: CollectionScreenNftCell, at index: Int) {
        if LikeService.shared.likes.contains(takeNftByIndex(index: index).id) {
            cell.setButtonLikeImage(image: .liked)
        }
    }
    
    func didTapAuthorLabel() {
        let presenter = WebViewScreenViewPresenter()
        let webViewScreen = WebViewScreenViewController(presenter: presenter)
        presenter.viewControllerInitialized(viewController: webViewScreen)
        webViewScreen.modalPresentationStyle = .fullScreen
        viewController?.show(webViewScreen)
    }
    
    private func takeNftByIndex(index: Int) -> NftModel {
        nfts[index]
    }
    
    private func updateCollection() {
        let oldCount = nfts.count
        let newCount = nftNetworkService.nfts.count
        nfts = nftNetworkService.nfts.sorted(by: ) { $0.rating > $1.rating }
        if oldCount != newCount {
            viewController?.updateCollection(oldCount: 0, newCount: newCount)
        }
        viewController?.viewUpdatedUI()
    }
}
