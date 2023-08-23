import Foundation
import UIKit

protocol MyNFTViewModelProtocol: AnyObject {
    var onChange: (() -> Void)? { get set }
    var onError: ((_ error: Error) -> Void)? { get set }
    
    var profile: ProfileModel? { get }
    var myNFTs: [NFTNetworkModel] { get }
    var likedIDs: [String] { get }
    var authors: [String: String] { get }
    var sort: MyNFTViewModel.Sort? { get set }
    
    func checkStoredSort()
    func saveSortOrder(order: MyNFTViewModel.Sort)
    func getMyNFTs(nftIDs: [String])
    func toggleLikeFromMyNFT(id: String)
    func checkNoNFT() -> Bool
    func setTitle() -> String
    func setImageForButton() -> UIImage
    func deleteNFT(atRow row: Int?)
    func notificationMyNFTliked(myNFTs: NFTNetworkModel)
}

final class MyNFTViewModel: MyNFTViewModelProtocol {
    var onChange: (() -> Void)?
    var onError: ((_ error: Error) -> Void)?
    private var networkClient: NetworkClient
    private(set) var profile: ProfileModel?
    private let dispatchGroup = DispatchGroup()
    
    var sort: Sort? {
        didSet {
            guard let sort else { return }
            myNFTs = applySort(by: sort)
        }
    }
    
    private(set) var myNFTs: [NFTNetworkModel] = [] {
        didSet {
            onChange?()
        }
    }
    
    private(set) var likedIDs: [String] {
        didSet {
            onChange?()
        }
    }
    
    private(set) var authors: [String: String] = [:] {
        didSet {
            onChange?()
        }
    }
    
    init(profile: ProfileModel){
        self.networkClient = DefaultNetworkClient()
        self.profile = profile
        likedIDs = profile.likes
        getMyNFTs(nftIDs: profile.nfts)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(unlikeNFTFromFavorites),
            name: NSNotification.Name(rawValue: "favoriteUnliked"),
            object: nil
        )
    }
    
    func getMyNFTs(nftIDs: [String]) {
        var loadedNFTs: [NFTNetworkModel] = []
        
        nftIDs.forEach { id in
            dispatchGroup.enter()
            networkClient.send(request: GetMyNFTRequest(id: id, item: .nft), type: NFTNetworkModel.self) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let nft):
                        self.getAuthors(nft: nft)
                        loadedNFTs.append(nft)
                        self.myNFTs = loadedNFTs
                    case .failure(let error):
                        self.dispatchGroup.leave()
                        self.onError?(error)
                        UIBlockingProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    
    func toggleLikeFromMyNFT(id: String) {
        if likedIDs.contains(id) {
            likedIDs.removeAll(where: { $0 == id })
            profile?.likes.removeAll(where: { $0 == id })
        } else {
            likedIDs.append(id)
            profile?.likes.append(id)
        }
        uploadData()
    }
    
    @objc
    private func unlikeNFTFromFavorites(notification: Notification) {
        let nftId = notification.object as? String
        self.likedIDs = likedIDs.filter({ $0 != nftId })
    }
    
    private func getAuthors(nft: NFTNetworkModel) {
        networkClient.send(request: GetMyNFTRequest(id: nft.author, item: .author), type: AuthorNetworkModel.self) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let author):
                    self.authors.updateValue(author.name, forKey: author.id)
                case .failure(let failure):
                    self.onError?(failure)
                    return
                }
                self.dispatchGroup.leave()
            }
        }
    }
    
    func uploadData() {
        networkClient.send(request: ProfileRequest(httpMethod: .put, dto: profile),
                           type: ProfileModel.self
        ) { _ in return }
    }
    
    private func applySort(by value: Sort) -> [NFTNetworkModel] {
        switch value {
        case .price:
            return myNFTs.sorted(by: { $0.price < $1.price })
        case .rating:
            return myNFTs.sorted(by: { $0.rating > $1.rating })
        case .name:
            return myNFTs.sorted(by: { $0.name < $1.name })
        }
    }
    
    func checkStoredSort() {
        if let sortOrder = UserDefaults.standard.string(forKey: AppConstants.String.sortOrder) {
            let order = Sort(rawValue: sortOrder)
            sort = order
        }
        sort = .rating
    }
    
    func saveSortOrder(order: MyNFTViewModel.Sort) {
        UserDefaults.standard.set(order.rawValue, forKey: AppConstants.String.sortOrder)
    }
    
    func checkNoNFT() -> Bool {
        return myNFTs.isEmpty
    }
    
    func setTitle() -> String {
        return myNFTs.isEmpty ? "" : "Мои NFT"
    }
    
    func setImageForButton() -> UIImage {
        return myNFTs.isEmpty ? UIImage() : UIImage.Icons.sort
    }
    
    func deleteNFT(atRow row: Int?) {
        guard let row else { return }
        let nftToRemove = myNFTs.remove(at: row)
        profile?.nfts.removeAll(where: {$0 == nftToRemove.id})
        uploadData()
    }
    
    func notificationMyNFTliked(myNFTs: NFTNetworkModel) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myNFTliked"), object: myNFTs)
    }
}

extension MyNFTViewModel {
    enum Sort: String {
        case price
        case rating
        case name
    }
}
