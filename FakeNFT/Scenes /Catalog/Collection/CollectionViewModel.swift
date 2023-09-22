import Foundation

final class CollectionViewModel: NSObject {
    let collection: NFTsCollectionNetworkModel
    
    var user: User?
    var nft: [NFTNetworkModel]?
    var profile: ProfileNetworkModel?
    var order: Order?
    
    var reloadData: (() -> Void)?
    
    init(collection: NFTsCollectionNetworkModel) {
        self.collection = collection
        super .init()
        fetchUserData(by: collection.author)
        fetchNFTData()
        fetchProfileData()
        fetchOrderData()
    }
    
    func fetchUserData(by id: String) {
        DefaultNetworkClient().send(request: UserIdRequest(userId: id), type: UserNetworkModel.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.user = User(with: data)
                DispatchQueue.main.async {
                    self?.reloadData?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("fetch user data error status - \(error)")
                }
            }
        }
    }
    
    func fetchNFTData() {
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(request: NFTRequest(), type: [NFTNetworkModel].self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.nft = data.map { $0 }
                    DispatchQueue.main.async { [weak self] in
                        self?.reloadData?()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("fetch nft data error status - \(error)")
                    }
                }
            }
        }
    }
    
    private func fetchOrderData() {
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(request: OrderRequest(), type: OrderNetworkModel.self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.order = Order(with: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.reloadData?()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("fetch order data error status - \(error)")
                    }
                }
            }
        }
    }
    
    private func fetchProfileData() {
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(request: ProfileRequest(), type: ProfileNetworkModel.self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.profile = data
                    DispatchQueue.main.async { [weak self] in                         self?.reloadData?()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("fetch profile data error status - \(error)")
                    }
                }
            }
        }
    }
    
    func updateLikeForNFT(with id: String) {
        var likes = profile?.likes
        if let index = likes?.firstIndex(of: id) {
            likes?.remove(at: index)
        } else {
            likes?.append(id)
        }
        guard let likes = likes,
              let id = profile?.id
        else { return }
        let dto = ProfileUpdateDTO(likes: likes, id: id)
        updateProfileData(with: dto)
    }
    
    private func updateProfileData(with dto: ProfileUpdateDTO) {
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(request: ProfileUpdateRequest(profileUpdateDTO: dto), type: ProfileNetworkModel.self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.profile = data
                    DispatchQueue.main.async {
                        self?.reloadData?()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("update order data error status \(error)")
                    }
                }
            }
        }
    }
    
    func updateCartForNFT(with id: String) {
        var nfts = order?.nfts
        if let index = nfts?.firstIndex(of: id) {
            nfts?.remove(at: index)
        } else {
            nfts?.append(id)
        }
        guard let nfts = nfts,
              let id = order?.id
        else { return }
        let dto = OrderUpdateDTO(nfts: nfts, id: id)
        updateOrderData(with: dto)
    }
    
    private func updateOrderData(with dto: OrderUpdateDTO) {
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(request: OrderUpdateRequest(orderUpdateDTO: dto), type: OrderNetworkModel.self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.order = Order(with: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.reloadData?()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("update order data status error - \(error)")
                    }
                }
            }
        }
    }
    
    func nfts(by id: String) -> NFTNetworkModel? {
        nft?.first { $0.id == id }
    }
    
    func isNFTLiked(with nftId: String) -> Bool {
        return profile?.likes.contains(nftId) ?? false
    }
    
    func isNFTInOrder(with nftId: String) -> Bool {
        return order?.nfts.contains(nftId) ?? false
    }
}
