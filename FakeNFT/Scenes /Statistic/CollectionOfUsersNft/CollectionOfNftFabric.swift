import Foundation

protocol LikesInteraction: AnyObject {
    
    func getProfile() -> Profile
    func getLikes() -> [String]
    func getLikesString() -> String
    func appendLike(by likeId: String)
    func deleteLike(by likeId: String)
    func updateLikes(with newProfile: Profile)
}

protocol BasketInteraction: AnyObject {
    
    func getBasket() -> Basket
    func getBasketNfts() -> [String]
    func getBasketString() -> String
    func appendNft(by id: String)
    func deleteNft(by id: String)
    func updateNfts(with newBasket: Basket)
}

struct Basket: Codable {
    var nfts: [String]
    
    func transformNfts() -> String {
        var transformLike = "nfts="
        transformLike += nfts.joined(separator: "%2C")
        return transformLike
    }
}

struct Profile: Codable {
    var likes: [String]
    
    func transformNfts() -> String {
        var transformLike = "likes="
        transformLike += likes.joined(separator: "%2C")
        return transformLike
    }
}

//MARK: - CollectionOfNftFabric
final class CollectionOfNftFabric {
    
    var onNeedUpdate: (() -> Void)?
    
    private var nfts: [String]
    private var nftsFromNetwork: [NftModel] = []
    private var nftNetworkService: NftNetworkService
    private var profileService: ProfileService
    
    private let dispatchGroup = DispatchGroup()
    
    private var nftsWithLike: Profile
    private var nftsOnBasket: Basket
    
    init(
        with nfts: [String]?,
        servicesAssembly: ServicesAssembly
    ) {
        self.nftsWithLike = Profile(likes: [])
        self.nftsOnBasket = Basket(nfts: [])
        
        self.nftNetworkService = servicesAssembly.nftNetworkService
        self.profileService = servicesAssembly.profileService
        
        guard let nfts = nfts else {
            self.nfts = []
            return
        }
        self.nfts = nfts
        
        setNftsFromNetwork()
    }
    
    func isEmpty() -> Bool {
        
        return nftsFromNetwork.isEmpty
    }
    
    func getNftsCount() -> Int {
        
        nftsFromNetwork.count
    }
    
    func getNfts() -> [String] {
        
        nfts
    }
    
    func getNft(by index: Int) -> NftModel {
        
        if index > nftsFromNetwork.count { return MockData.shared.placeholderNft }
        return nftsFromNetwork[index]
    }
    
    func setNftsFromNetwork() {
        for nftId in nfts {
            self.dispatchGroup.enter()
            self.getNftFromNetwork(with: nftId)
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.onNeedUpdate?()
        }
    }
    
    func getNftFromNetwork(with id: String) {
        DispatchQueue.main.async {
            self.nftNetworkService.loadNft(by: id) { [weak self] result in
                defer { self?.dispatchGroup.leave() }
                switch result {
                case .success(let nftFromNetwork):
                    self?.nftsFromNetwork.append(nftFromNetwork)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

//MARK: - LikesInteraction
extension CollectionOfNftFabric: LikesInteraction {
    
    func getProfile() -> Profile {
        
        nftsWithLike
    }
    
    func getLikes() -> [String] {
        
        nftsWithLike.likes
    }
    
    func getLikesString() -> String {
        
        nftsWithLike.transformNfts()
    }
    
    func appendLike(by like: String) {
        
        nftsWithLike.likes.append(like)
    }
    
    func deleteLike(by likeId: String) {
        
        nftsWithLike.likes.removeAll {
            $0 == likeId
        }
    }
    
    func updateLikes(with newProfile: Profile) {
        
        nftsWithLike.likes = newProfile.likes
    }
}

//MARK: - BasketInteraction
extension CollectionOfNftFabric: BasketInteraction {
    
    func getBasket() -> Basket {
        
        nftsOnBasket
    }
    
    func getBasketNfts() -> [String] {
        
        nftsOnBasket.nfts
    }
    
    func getBasketString() -> String {
        
        nftsOnBasket.transformNfts()
    }
    
    func appendNft(by id: String) {
        
        nftsOnBasket.nfts.append(id)
    }
    
    func deleteNft(by id: String) {
        
        nftsOnBasket.nfts.removeAll {
            $0 == id
        }
    }
    
    func updateNfts(with newBasket: Basket) {
        
        nftsOnBasket.nfts = newBasket.nfts
    }
}
