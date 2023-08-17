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
    var catalogDataModel: CatalogDataModel { get set }
    func takeNfts() -> [NftModel]
    func takeInitialNftCount() -> Int
    func takeActualNftCount() -> Int
    func takeNftCoverLink() -> String?
    func takeNftName() -> String
    func takeNftDescription() -> String
    func createWebViewScreen() -> WebViewScreenViewController
    func makeFetchRequest()
}
