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
    var collectionName: String {
        catalogDataModel.name
    }
    var collectionCover: String {
        catalogDataModel.cover
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
    
    func viewMadeFetchRequest() {
        authorNetworkService.fetchAuthor(id: catalogDataModel.author)
        nftNetworkService.fetchNft(id: catalogDataModel.author)
    }
    
    func viewDidRequestNftFromNfts(index: Int) -> NftModel {
        nfts[index]
    }
    
    func viewDidRequestTextViewHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let textView = UITextView()
        textView.text = text
        textView.font = font
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
        textView.frame.size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let newSize = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return newSize.height
    }
    
    func viewDidRequestLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = font
        label.frame.size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let newSize = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return newSize.height
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
