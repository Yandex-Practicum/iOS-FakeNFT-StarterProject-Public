import Foundation

//MARK: - Protocol
protocol NftCellFabricProtocol {
    
    func getAvatar() -> URL?
    func getRating() -> Int
    func getName() -> String
    func getCost() -> String
}

//MARK: - NftCellFabric
final class NftCellFabric {
    
    weak var delegate: NftCellDelegate?
    weak var likesInteractor: LikesInteraction?
    weak var basketInteractor: BasketInteraction?
    
    private var nft: NftModel
    
    private let basketService: BasketService
    private let profileService: ProfileService
    
    init(
        nft: NftModel,
        servicesAssembly: ServicesAssembly,
        with delegate: NftCellDelegate,
        interactorAssembly: InteractorsAssembly
    ) {
        self.nft = nft
        self.basketService = servicesAssembly.basketService
        self.profileService = servicesAssembly.profileService
        
        self.delegate = delegate
        self.likesInteractor = interactorAssembly.likesInteractor
        self.basketInteractor = interactorAssembly.basketInteractor
        
        setNftOnBasket()
        setNftWithLike()
    }
}

//MARK: - NftCellFabricProtocol
extension NftCellFabric: NftCellFabricProtocol {
    
    func getNft() -> NftModel {
        
        return nft
    }
    
    func getAvatar() -> URL? {
        
        nft.images[0]
    }
    
    func getRating() -> Int {
        
        nft.rating
    }
    
    func getName() -> String {
        
        nft.name
    }
    
    func getCost() -> String {
        
        ("\(nft.rating) ETH")
    }
}

//MARK: - BasketNetworkService
extension NftCellFabric {
    
    func setNftOnBasket() {
        
        basketService.loadNft { [weak self] result in
            switch result {
            case .success(let basket):
                self?.basketInteractor?.updateNfts(with: basket)
                self?.delegate?.setBasket()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func appendNftToBasket(with id: String) {
        
        basketInteractor?.appendNft(by: id)
        updateBasket()
    }
    
    func deleteNftFromBasket(with id: String) {
        
        basketInteractor?.deleteNft(by: id)
        updateBasket()
    }
    
    func updateBasket() {
        
        guard let dto = basketInteractor?.getBasket() else { return }
        basketService.updateNft(basket: dto) { [weak self] result in
            switch result {
            case .success(let basket):
                self?.delegate?.setBasket()
                self?.basketInteractor?.updateNfts(with: basket)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func isOnBasket() -> Bool {
        
        guard let nfts = basketInteractor?.getBasketNfts() else { return false}
        return nfts.contains {
            $0 == nft.id
        }
    }
}

//MARK: - LikeNetworkService
extension NftCellFabric {
    
    func setNftWithLike() {
        
        profileService.loadNft { [weak self] result in
            switch result {
            case .success(let profile):
                self?.likesInteractor?.updateLikes(with: profile)
                self?.delegate?.setLike()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func appendNftWithLike(with id: String) {
        
        likesInteractor?.appendLike(by: id)
        updateLikes()
    }
    
    func deleteNftWithoutLike(with id: String) {
        
        likesInteractor?.deleteLike(by: id)
        updateLikes()
    }
    
    func updateLikes() {
        
        guard let dto = likesInteractor?.getProfile() else { return }
        profileService
            .updateLikes(
                profile: dto//likesInteractor?.getLikesString()
            ) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.delegate?.setLike()
                self?.likesInteractor?.updateLikes(with: profile)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func isLiked() -> Bool {
        
        guard let likes = likesInteractor?.getLikes() else { return false }
        return likes.contains {
            $0 == nft.id
        }
    }
}
