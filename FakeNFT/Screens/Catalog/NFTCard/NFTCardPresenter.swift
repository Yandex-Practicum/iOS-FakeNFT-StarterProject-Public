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
    var nftArray: Nft { get }
    var nftArrays: [Nft] { get }
    var cryptos: [Crypto] { get }
    func getUserProfile() -> ProfileModel?
    func getUserOrder() -> OrderModel?
    func presentCollectionViewData()
    var currentIndex: Int { get set}
    func setupData(data: Nft)
    var ima: [URL] { get set }
    var nftCollection: NFTCollection { get }
    func setupDataNft(data: NFTCollection)
    func toggleLikeStatus(model: Nft)
    func toggleCartStatus(model: Nft)
    var userProfile: ProfileModel? { get set }
    var userOrder: OrderModel? { get set }
    var indexLike: Bool { get set }
    func isAlreadyInCart(nftId: String) -> Bool
    func isAlreadyLiked(nftId: String) -> Bool
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
    var userProfile: ProfileModel?
    var userOrder: OrderModel?
    var cryptos: [Crypto] = [Crypto(name: "Bitcoin", symbol: "BTC", iconName: "Bitcoin", price: 18.11, amount: 0.1),
                             Crypto(name: "ApeCoin", symbol: "APE", iconName: "Apecoin", price: 18.11, amount: 0.1),
                             Crypto(name: "Cardano", symbol: "ADA", iconName: "Cardano", price: 18.11, amount: 0.1),
                             Crypto(name: "Dogecoin", symbol: "DOGE", iconName: "Dogcoin", price: 18.11, amount: 0.1),
                             Crypto(name: "Ethereum", symbol: "ETH", iconName: "Ethereum", price: 18.11, amount: 0.1),
                             Crypto(name: "Shiba Inu", symbol: "SHIB", iconName: "ShibaInu", price: 18.11, amount: 0.1),
                             Crypto(name: "Solana", symbol: "SOL", iconName: "Solana", price: 18.11, amount: 0.1),
                             Crypto(name: "Tether", symbol: "USDT", iconName: "Tether", price: 18.11, amount: 0.1)]

    let cartController: CartControllerProtocol
    var userURL: String?
    var nftArray: Nft
    var nftArrays: [Nft]
    var profileModel: [ProfileModel] = []
    var currentIndex = 0
    var ima: [URL] = []
    var nftCollection: NFTCollection
    var indexLike = false
    init(nftArray: Nft,
         dataProvider: CollectionDataProvider,
         cartController: CartControllerProtocol,
         nftCollection: NFTCollection,
         nftArrayss: [Nft],
         userProfile: ProfileModel,
         userOrder: OrderModel,
         indexLike: Bool
    ) {
        self.nftArray = nftArray
        self.dataProvider = dataProvider
        self.cartController = cartController
        self.nftCollection = nftCollection
        self.nftArrays = nftArrayss
        self.userProfile = userProfile
        self.userOrder = userOrder
        self.indexLike = indexLike
    }

    func setupData(data: Nft) {
        viewController?.setupData(data: data)
    }

    func setupDataNft(data: NFTCollection) {
        viewController?.setupDataNft(data: data)
    }

    func presentCollectionViewData() {
        let viewData = CatalogCollectionViewData(
            coverImageURL: "\(nftArray.images.first!)",
            title: nftArray.name,
            description: nftArray.author,
            authorName: nftArray.author,
            images: nftArray.images)
        viewController?.renderViewData(viewData: viewData)
    }

    func toggleLikeStatus(model: Nft) {
        guard let profileModel = self.userProfile else {
            return
        }
        let updatedLikes = self.isAlreadyLiked(nftId: model.id)
        ? profileModel.likes?.filter { $0 != model.id }
        : (profileModel.likes ?? []) + [model.id]

        let updatedProfileModel = profileModel.update(newLikes: updatedLikes)
        dataProvider.updateUserProfile(with: updatedProfileModel) { updateResult in
            switch updateResult {
            case .success(let result):
                self.setUserProfile(result)
                self.viewController?.reloadVisibleCells()
            case .failure:
                break
            }
        }
        self.viewController?.reloadVisibleCells()
    }

    func toggleCartStatus(model: Nft) {
        guard let orderModel = self.userOrder else {
            return
        }

        let updatedNfts = isAlreadyInCart(nftId: model.id)
        ? orderModel.nfts?.filter { $0 != model.id }
        : (orderModel.nfts ?? []) + [model.id]

        let updatedOrderModel = orderModel.update(newNfts: updatedNfts)

        dataProvider.updateUserOrder(with: updatedOrderModel) { updateResult in
            switch updateResult {
            case .success(let result):
                self.setUserOrder(result)
                self.viewController?.reloadVisibleCells()
            case .failure:
                break
            }
        }
    }

    func setUserProfile(_ profile: ProfileModel) {
        self.userProfile = profile
    }

    func setUserOrder(_ order: OrderModel) {
        self.userOrder = order
    }

    func loadUserProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        dataProvider.getUserProfile { [weak self] result in
            switch result {
            case .success(let profileModel):
                self?.setUserProfile(profileModel)
                completion(.success(profileModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadUserOrder(completion: @escaping (Result<OrderModel, Error>) -> Void) {
        dataProvider.getUserOrder { [weak self] result in
            switch result {
            case .success(let order):
                self?.setUserOrder(order)
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func isAlreadyLiked(nftId: String) -> Bool {
        return self.userProfile?.likes?.contains { $0 == nftId } == true
    }

    func isAlreadyInCart(nftId: String) -> Bool {
        return self.userOrder?.nfts?.contains {$0 == nftId } == true
    }
}
