//
//  CollectionScreenViewProtocol.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import UIKit

protocol CollectionScreenViewControllerProtocol: AnyObject {
    func updateCollection(oldCount: Int, newCount: Int)
    func updateAuthor()
    func removeHud()
    func viewReadinessCheck()
    func authorLabelTap()
}

protocol CollectionScreenViewPresenterProtocol {
    var actualNftsCount: Int { get }
    var collectionName: String { get }
    var collectionCover: String { get }
    var collectionDescription: String { get }
    var initialNftCount: Int { get }
    var webViewScreen: WebViewScreenViewController { get }
    func viewMadeFetchRequest()
    func viewDidRequestNftFromNfts(index: Int) -> NftModel
    func viewDidRequestTextViewHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat
    func viewDidRequestLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat
}
