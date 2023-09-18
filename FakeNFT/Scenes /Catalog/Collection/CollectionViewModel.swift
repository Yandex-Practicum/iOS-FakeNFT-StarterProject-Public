import Foundation

final class CollectionViewModel: NSObject {
    let collection: NFTsCollectionNetworkModel
    
    var user: User?
    var nft: [NFTNetworkModel]?
    var profile: ProfileNetworkModel?
    var order: OrderNetworkModel?
    
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
                print("fetch user data error status - \(error)")
            }
        }
    }
    
    func fetchNFTData() {
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(request: NFTRequest(), type: [NFTNetworkModel].self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.nft = data.map { $0 }
                    DispatchQueue.main.async {
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
                    DispatchQueue.main.async {
                        self?.reloadData?()
                    }
                case .failure(let error):
                        print("fetch order data error status - \(error)")
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
                    DispatchQueue.main.async {
                        self?.reloadData?()
                    }
                case .failure(let error):
                    print("fetch profile data error status - \(error)")
                }
            }
        }
    }
    
    func nfts(by id: String) -> NFTNetworkModel? {
        nft?.first { $0.id == id }
    }
    
    func isNFTLiked(with nftId: String) -> Bool {
        return ((profile?.likes.contains(nftId)) != nil)
    }
    
    func isNFTInOrder(with nftId: String) -> Bool {
        return ((order?.nfts.contains(nftId)) != nil)
    }
}
