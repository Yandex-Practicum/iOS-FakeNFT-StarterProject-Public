import Foundation

protocol FavoritesViewModelProtocol: AnyObject {
    var onChange: (() -> Void)? { get set }
    var onError: ((_ error: Error) -> Void)? { get set }
    var likedNFTs: [NFTNetworkModel]? { get }
    
    func getLikedNFTs(likedIDs: [String])
    func putLikedNFTs(likedIDs: [String])
    func favoriteUnliked(id: String)
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
    var onChange: (() -> Void)?
    var onError: ((_ error: Error) -> Void)?
    
    private let networkClient = DefaultNetworkClient()
    
    private(set) var likedNFTs: [NFTNetworkModel]? {
        didSet {
            onChange?()
        }
    }
    
    init(likedIDs: [String]){
        self.likedNFTs = []
        getLikedNFTs(likedIDs: likedIDs)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(myNFTliked),
            name: NSNotification.Name(rawValue: "myNFTliked"),
            object: nil
        )
    }
    
    func getLikedNFTs(likedIDs: [String]) {
        var loadedNFTs: [NFTNetworkModel] = []
        
        likedIDs.forEach { id in
            networkClient.send(request: GetMyNFTRequest(id: id, item: .nft), type: NFTNetworkModel.self) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let nft):
                        loadedNFTs.append(nft)
                        if loadedNFTs.count == likedIDs.count {
                            self?.likedNFTs? = loadedNFTs
                            UIBlockingProgressHUD.dismiss()
                        }
                    case .failure(let error):
                        self?.onError?(error)
                        UIBlockingProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    
    func putLikedNFTs(likedIDs: [String]) {
        let request = PutFavoritesRequest(likes: likedIDs)
        UIBlockingProgressHUD.show()
        networkClient.send(request: request, type: FavoritesNetworkModel.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likesUpdated"), object: likedIDs.count)
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    self?.onError?(error)
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    func favoriteUnliked(id: String) {
        guard var likedNFTs = self.likedNFTs else { return }
        likedNFTs = likedNFTs.filter({ $0.id != id })
        self.likedNFTs = likedNFTs
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "favoriteUnliked"), object: id)
        let likedIDs = likedNFTs.map({ $0.id })
        self.putLikedNFTs(likedIDs: likedIDs)
    }
    
    @objc
    private func myNFTliked(notification: Notification) {
        guard var likedNFTs = likedNFTs,
              let myNFTid = notification.object as? NFTNetworkModel else { return }
        if !likedNFTs.contains(where: { $0.id == myNFTid.id }) {
            likedNFTs.append(myNFTid)
        } else {
            likedNFTs = likedNFTs.filter { $0.id != myNFTid.id }
        }
        self.likedNFTs = likedNFTs
        
        let likedIDs = likedNFTs.map ({ $0.id })
        putLikedNFTs(likedIDs: likedIDs)
    }
}
