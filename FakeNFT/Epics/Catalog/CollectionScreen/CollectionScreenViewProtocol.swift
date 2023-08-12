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
}

protocol CollectionScreenViewPresenterProtocol {
    var collectionScreenViewController: CollectionScreenViewControllerProtocol? { get set }
    func configureCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func takeInitialNftCount() -> Int
    func takeActualNftCount() -> Int
    func takeNftCoverLink() -> String?
    func takeNftName() -> String
    func takeNftDescription() -> String
    func createWebViewScreen() -> WebViewScreenViewController
    func makeFetchRequest()
}
