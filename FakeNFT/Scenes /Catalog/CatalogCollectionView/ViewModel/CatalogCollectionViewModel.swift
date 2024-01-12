//
//  CatalogCollectionViewModel.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 07.11.2023.
//

import Foundation
import Combine

final class CatalogCollectionViewModel: CatalogCollectionViewModelProtocol {

    // MARK: - public properties
    @Published var nftsLoadingIsCompleted: Bool = false
    @Published var author: Author?
    @Published var networkError: Error?
    var nftsLoaderPublisher: Published<Bool>.Publisher { $nftsLoadingIsCompleted }
    var authorPublisher: Published<Author?>.Publisher { $author }
    var networkErrorPublisher: Published<Error?>.Publisher { $networkError }
    var nfts: [Nft] = []
    var catalogCollection: Catalog
    var profileLikes: [String] = LikesStorage.shared.likes

    // MARK: - private properties
    private let collectionService: CatalogCollectionService
    private var likesLoadingIsCompleted = false
    private var addedToCartNfts = PurchaseCartStorage.shared.nfts

    init(catalogCollection: Catalog, service: CatalogCollectionService) {
        self.catalogCollection = catalogCollection
        self.collectionService = service
        fetchData()
    }

    // MARK: - public methods
    func fetchData() {
        networkError = nil
        if !nftsLoadingIsCompleted {
            clearNfts()
            fetchNfts()
        }
        if author == nil {
            fetchAuthorProfile()
        }
    }

    func nftIsLiked(_ id: String) -> Bool {
        profileLikes.contains(id)
    }

    func nftsIsAddedToCart(_ id: String) -> Bool {
        addedToCartNfts.contains(id)
    }

    func calculateCollectionViewHeight(numberOfCellsInRow: Int) -> CGFloat {
        let numberOfCells = catalogCollection.nfts.count
        let height = 192
        let spacing = 9
        var result: Int = 0
        if numberOfCells % numberOfCellsInRow == 0 {
            result = (numberOfCells / numberOfCellsInRow) * height +
            ((numberOfCells / numberOfCellsInRow) * spacing)
        } else {
            result = (numberOfCells / numberOfCellsInRow + 1) * height +
            ((numberOfCells / numberOfCellsInRow) * spacing)
        }
        return CGFloat(result)
    }

    func changeLikeForNft(with id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if profileLikes.contains(id) {
            profileLikes.removeAll { like in
                like == id
            }
        } else {
            profileLikes.append(id)
        }

        let profile = ProfileLike(likes: profileLikes)

        collectionService.putProfileLikes(profile: profile) { result in
            switch result {
            case .success(let profile):
                LikesStorage.shared.likes = profile.likes
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func switchNftBasketState(with id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if addedToCartNfts.contains(id) {
            addedToCartNfts.removeAll { nftId in
                nftId == id
            }
        } else {
            addedToCartNfts.append(id)
        }
        let cart = PurchaseCart(nfts: addedToCartNfts)

        collectionService.putNftsToCart(cart: cart) { result in
            switch result {
            case .success(let cart):
                PurchaseCartStorage.shared.nfts = cart.nfts
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - private methods
    private func fetchNfts() {
        catalogCollection.nfts.forEach { id in
            collectionService.loadNftForCollection(id: String(id)) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let nft):
                    self.nfts.append(nft)
                    if self.nfts.count == self.catalogCollection.nfts.count {
                        self.sortNfts()
                        self.nftsLoadingIsCompleted = true
                    }
                case .failure(let error):
                    self.clearNfts()
                    if self.networkError == nil && !self.nftsLoadingIsCompleted {
                        self.networkError = error
                    }
                }
            }
        }
    }

    private func fetchAuthorProfile() {
        collectionService.fetchAuthorProfile(id: catalogCollection.authorID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let authorLink):
                self.author = authorLink
            case .failure(let error):
                if self.networkError == nil && self.author == nil {
                    self.networkError = error
                }
            }
        }
    }

    private func sortNfts() {
        nfts.sort { $0.name < $1.name }
    }

    private func clearNfts() {
        nfts.removeAll()
    }
}
