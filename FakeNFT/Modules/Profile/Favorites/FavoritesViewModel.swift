import UIKit

protocol FavoritesViewModelProtocol: AnyObject {
    var onChange: (() -> Void)? { get set }
    var onError: ((_ error: Error) -> Void)? { get set }
    var likedNFTs: [NFTNetworkModel]? { get }
    
    func getLikedNFTs(likedIDs: [String])
    func putLikedNFTs(likedIDs: [String])
    func favoriteUnliked(id: String)
    func showAlert(_ model: AlertModel) -> UIAlertController
    func setTitle() -> String
    func checkNoNFT() -> Bool
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
    var onChange: (() -> Void)?
    var onError: ((_ error: Error) -> Void)?
    
    private var networkClient: NetworkClient
    private let dispatchGroup = DispatchGroup()
    private var profile: ProfileModel?
    
    private(set) var likedNFTs: [NFTNetworkModel]?{
        didSet {
            onChange?()
        }
    }
    
    init(networkClient: NetworkClient, profile: ProfileModel){
        self.networkClient = networkClient
        getLikedNFTs(likedIDs: profile.likes)
        
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
            self.dispatchGroup.enter()
            networkClient.send(request: GetMyNFTRequest(id: id, item: .nft), type: NFTNetworkModel.self) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let nft):
                        loadedNFTs.append(nft)
                        self.likedNFTs = loadedNFTs
                        self.dispatchGroup.leave()
                    case .failure(let error):
                        self.onError?(error)
                        self.dispatchGroup.leave()
                    }
                }
            }
        }
    }
    
    func putLikedNFTs(likedIDs: [String]) {
        networkClient.send(request: ProfileRequest(httpMethod: .put, dto: profile),
                           type: ProfileModel.self
        ) { _ in
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likesUpdated"), object: likedIDs.count)
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
    
    func showAlert(_ model: AlertModel) -> UIAlertController {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: model.styleAction,
            handler: model.completion
        )
        
        alert.addAction(action)
        return alert
    }
    
    func setTitle() -> String {
        guard let nft = likedNFTs else { return "" }
        return nft.isEmpty ? "" : "Избранные NFT"
    }
    
    func checkNoNFT() -> Bool {
        guard let nft = likedNFTs else { return false }
        return nft.isEmpty
    }
}
