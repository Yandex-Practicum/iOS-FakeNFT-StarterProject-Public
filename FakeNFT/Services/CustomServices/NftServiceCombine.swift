import Combine
import Foundation

// MARK: - Typealiases

typealias NftCombineCompletion = AnyPublisher<Nft, NetworkClientError>
typealias NftListCombineCompletion = AnyPublisher<[Nft], NetworkClientError>
typealias CartItemsCompletion = AnyPublisher<[Nft], NetworkClientError>
typealias OrderCompletion = AnyPublisher<Order, NetworkClientError>
typealias ProfileCombineCompletion = AnyPublisher<Profile, NetworkClientError>

// MARK: - NftServiceCombine

protocol NftServiceCombine {
    
    //MARK: NFT Methods
    
    func loadNft(id: String) -> NftCombineCompletion
    func loadAllNfts(forProfileId profileId: String) -> NftListCombineCompletion
    func loadFavoriteNfts(profileId: String) -> NftListCombineCompletion
    
    //MARK: Profile Methods
    
    func loadProfile(id: String) -> ProfileCombineCompletion
    func updateProfile(profileId: String, name: String?, description: String?, website: String?, likes: [String]?, avatar: String?) -> ProfileCombineCompletion
    
    // Cart Methods
    
    func getCartItems() -> CartItemsCompletion
    func updateOrder(id: String, nftIds: [String]) -> OrderCompletion
}

final class NftServiceCombineImp: NftServiceCombine {
    let networkClient: NetworkClientCombine
    let storage: NftStorage
    private var currentOrderId: String = "1"
    
    init(networkClient: NetworkClientCombine, storage: NftStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    // MARK: - NFT Methods
    
    func loadNft(id: String) -> NftCombineCompletion {
        if let cachedNft = storage.getNft(with: id) {
            return Just(cachedNft)
                .setFailureType(to: NetworkClientError.self)
                .handleEvents(receiveOutput: { nft in
                    print("Cached NFT loaded: \(nft)")
                })
                .eraseToAnyPublisher()
        }
        
        guard let request = ApiRequestBuilder.getNft(nftId: id) else {
            return Fail(error: NetworkClientError.custom("Invalid NFT ID for request"))
                .eraseToAnyPublisher()
        }
        
        return networkClient.send(request: request, type: Nft.self)
            .handleEvents(receiveOutput: { [weak self] nft in
                self?.storage.saveNft(nft)
            })
            .eraseToAnyPublisher()
    }
    
    func loadAllNfts(forProfileId profileId: String) -> NftListCombineCompletion {
        guard let profileRequest = ApiRequestBuilder.getProfile(profileId: profileId) else {
            return Fail(error: NetworkClientError.custom("Invalid profile ID for request"))
                .eraseToAnyPublisher()
        }
        
        return networkClient.send(request: profileRequest, type: Profile.self)
            .flatMap { profile -> NftListCombineCompletion in
                let nftPublishers = profile.nfts.map { nftId in
                    self.loadNft(id: nftId).eraseToAnyPublisher()
                }
                return Publishers.MergeMany(nftPublishers).collect().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func loadFavoriteNfts(profileId: String) -> NftListCombineCompletion {
        guard let request = ApiRequestBuilder.getProfile(profileId: profileId) else {
            return Fail(error: NetworkClientError.custom("Invalid Profile ID for request"))
                .eraseToAnyPublisher()
        }
        return networkClient.send(request: request, type: Profile.self)
            .flatMap { profile -> NftListCombineCompletion in
                let nftIds = profile.likes
                let nftPublishers = nftIds.map { nftId in
                    self.loadNft(id: nftId)
                }
                return Publishers.MergeMany(nftPublishers)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Profile Methods
    
    func loadProfile(id: String) -> ProfileCombineCompletion {
        guard let request = ApiRequestBuilder.getProfile(profileId: id) else {
            return Fail(error: NetworkClientError.custom("Invalid Profile ID for request"))
                .eraseToAnyPublisher()
        }
        return networkClient.send(request: request, type: Profile.self)
            .eraseToAnyPublisher()
    }
    
    func updateProfile(profileId: String, name: String?, description: String?, website: String?, likes: [String]?, avatar: String?) -> ProfileCombineCompletion {
        guard let request = ApiRequestBuilder.updateProfile(profileId: profileId, name: name, description: description, website: website, likes: likes, avatar: avatar) else {
            return Fail(error: NetworkClientError.urlSessionError).eraseToAnyPublisher()
        }
        
        return networkClient.send(request: request, type: Profile.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Cart Methods
    
    func getCartItems() -> CartItemsCompletion {
        guard let request = ApiRequestBuilder.getOrder(orderId: currentOrderId) else {
            return Fail(error: NetworkClientError.custom("Unable to form order request")).eraseToAnyPublisher()
        }
        
        return networkClient.send(request: request, type: Order.self)
            .flatMap { [weak self] order -> CartItemsCompletion in
                guard let self = self else { return Just([]).setFailureType(to: NetworkClientError.self).eraseToAnyPublisher() }
                guard !order.nfts.isEmpty else {
                    return Just([]).setFailureType(to: NetworkClientError.self).eraseToAnyPublisher()
                }
                let nftPublishers = order.nfts.map { id in
                    self.loadNft(id: id)
                }
                return Publishers.MergeMany(nftPublishers).collect().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func updateOrder(id: String, nftIds: [String]) -> OrderCompletion {
        guard let request = ApiRequestBuilder.updateOrder(orderId: id, nftIds: nftIds) else {
            return Fail(error: NetworkClientError.custom("Unable to form update order request")).eraseToAnyPublisher()
        }
        
        return networkClient.send(request: request, type: Order.self)
            .mapError { NetworkClientError.urlRequestError($0) }
            .eraseToAnyPublisher()
    }
}
