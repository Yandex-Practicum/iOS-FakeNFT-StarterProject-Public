//
//  CatalogСollectionPresenter.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import Foundation

protocol CartControllerProtocol {
    var delegate: CartControllerDelegate? { get set }
    var cart: [Nft] { get }
    func addToCart(_ nft: Nft, completion: (() -> Void)?)
    func removeFromCart(_ id: String, completion: (() -> Void)?)
    func removeAll(completion: (() -> Void)?)
}

protocol CartControllerDelegate: AnyObject {
    func cartCountDidChanged(_ newCount: Int)
}

// MARK: - Protocol

protocol CatalogСollectionPresenterProtocol: AnyObject {
    var viewController: CatalogСollectionViewControllerProtocol? { get set }
    var userURL: String? { get }
    var nftArray: [Nft] { get }
    func loadNFTs()
    func getUserProfile() -> ProfileModel?
    func getUserOrder() -> OrderModel?
    func loadUserProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void)
    func loadUserOrder(completion: @escaping (Result<OrderModel, Error>) -> Void)
    func isAlreadyLiked(nftId: String) -> Bool
    func isAlreadyInCart(nftId: String) -> Bool
    func presentCollectionViewData()
    func toggleLikeStatus(model: Nft)
    func toggleCartStatus(model: Nft)
    var userProfile: ProfileModel? { get set }
    var userOrder: OrderModel? { get set }
    var indexLike: Bool { get set }
}

// MARK: - Final Class

final class CatalogСollectionPresenter: CatalogСollectionPresenterProtocol {
    var indexLike = false
    func getUserProfile() -> ProfileModel? {
        return self.userProfile
    }

    func getUserOrder() -> OrderModel? {
        return self.userOrder
    }

    weak var viewController: CatalogСollectionViewControllerProtocol?
    private var dataProvider: CollectionDataProvider
    var userProfile: ProfileModel?
    var userOrder: OrderModel?

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
            authorName: nftModel.author,
            images: [])
        viewController?.renderViewData(viewData: viewData)
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

    func loadNFTs() {
        var nftArray: [Nft] = []
        let group = DispatchGroup()

        for nft in nftModel.nfts {
            group.enter()
            dataProvider.loadNFTsBy(id: nft) { result in
                switch result {
                case .success(let data):
                    nftArray.append(data)
                case .failure: break
                }
                group.leave()
            }
        }
        group.wait()
        group.notify(queue: .main) {
            self.nftArray = nftArray
            self.viewController?.reloadCollectionView()
        }

        self.loadUserProfile { updateResult in
            switch updateResult {
            case .success:
                self.viewController?.reloadVisibleCells()
            case .failure:
                break
            }
        }

        self.loadUserOrder { updateResult in
            switch updateResult {
            case .success:
                self.viewController?.reloadVisibleCells()
            case .failure:
                break
            }
        }
    }

    func isAlreadyLiked(nftId: String) -> Bool {
        return self.userProfile?.likes?.contains { $0 == nftId } == true
    }

    func isAlreadyInCart(nftId: String) -> Bool {
        return self.userOrder?.nfts?.contains {$0 == nftId } == true
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
}
