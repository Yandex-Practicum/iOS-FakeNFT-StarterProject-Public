//
//  NFTCardPresenter.swift
//  FakeNFT
//
//  Created by Денис Николаев on 02.08.2024.
//

import Foundation

// MARK: - Protocol

protocol NFTCardPresenterProtocol: AnyObject {
    var viewController: NFTCardViewControllerProtocol? { get set }
    var userURL: String? { get }
    var nftArray: [Nft] { get }
    func getUserProfile() -> ProfileModel?
    func getUserOrder() -> OrderModel?
    func presentCollectionViewData()
}

// MARK: - Final Class

final class NFTCardPresenter: NFTCardPresenterProtocol {

    func getUserProfile() -> ProfileModel? {
        return self.userProfile
    }

    func getUserOrder() -> OrderModel? {
        return self.userOrder
    }

    weak var viewController: NFTCardViewControllerProtocol?
    private var dataProvider: CollectionDataProvider
    private var userProfile: ProfileModel?
    private var userOrder: OrderModel?

    let cartController: CartControllerProtocol
    let nftModel: NFTCollection
    var userURL: String?
    var nftArray: [Nft] = []
    var profileModel: [ProfileModel] = []

    init(nftModel: NFTCollection, dataProvider: CollectionDataProvider, cartController: CartControllerProtocol) {
        self.nftModel = nftModel
        self.dataProvider = dataProvider
        self.cartController = cartController
    }

    func presentCollectionViewData() {
        let viewData = CatalogCollectionViewData(
            coverImageURL: nftModel.cover,
            title: nftModel.name,
            description: nftModel.description,
            authorName: nftModel.author)
        viewController?.renderViewData(viewData: viewData)
    }
}
