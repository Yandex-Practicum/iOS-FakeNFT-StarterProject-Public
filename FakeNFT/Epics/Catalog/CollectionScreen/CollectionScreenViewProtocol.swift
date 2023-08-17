//
//  CollectionScreenViewProtocol.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import UIKit

protocol CollectionScreenViewControllerProtocol: AnyObject {
    var presenter: CollectionScreenViewPresenterProtocol? { get set }
    func updateCollection(oldCount: Int, newCount: Int)
    func updateAuthor()
    func removeHud()
    func viewReadinessCheck()
    func authorLabelTap()
}

protocol CollectionScreenViewPresenterProtocol {
    var collectionScreenViewController: CollectionScreenViewControllerProtocol? { get set }
    var actualNftsCount: Int { get }
    var takeCollectionName: String { get }
    var takeCollectionCover: String { get }
    var takeCollectionDescription: String { get }
    var takeInitialNftCount: Int { get }
    var createWebViewScreen: WebViewScreenViewController { get }
    func makeFetchRequest()
    func takeNftFromNfts(index: Int) -> NftModel
}
