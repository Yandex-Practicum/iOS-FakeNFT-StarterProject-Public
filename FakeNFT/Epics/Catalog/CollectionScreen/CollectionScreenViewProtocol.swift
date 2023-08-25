//
//  CollectionScreenViewProtocol.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import UIKit

protocol CollectionScreenViewControllerProtocol: AnyObject {
    var currentNumberOfNft: Int { get }
    func updateCollection(oldCount: Int, newCount: Int)
    func updateAuthor()
    func showHud()
    func removeHud()
    func viewUpdatedUI()
    func authorLabelTap()
    func show(_ webView: WebViewScreenViewController)
}

protocol CollectionScreenViewPresenterProtocol {
    var actualNftsCount: Int { get }
    var collectionName: String { get }
    var collectionCover: URL? { get }
    var collectionDescription: String { get }
    var authorName: String? { get }
    func viewControllerInitialized(viewController: CollectionScreenViewControllerProtocol)
    func viewDidLoad()
    func viewStartedCellConfiguration(at index: Int) -> NftModel
    func viewWillSetImage(with link: String) -> URL?
    func viewUpdatedUI(in cell: CollectionScreenMainContentCell)
    func viewWillUpdateBasket(in cell: CollectionScreenNftCell, at index: Int)
    func viewWillUpdateLike(in cell: CollectionScreenNftCell, at index: Int)
    func didTapAuthorLabel()
}
