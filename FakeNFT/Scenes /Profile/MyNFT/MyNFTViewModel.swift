import Foundation

protocol MyNFTViewModelProtocol: AnyObject {
    var onChange: (() -> Void)? { get set }
    var onError: ((_ error: Error) -> Void)? { get set }
    
    var profile: ProfileModel? { get }
    var myNFTs: [NFTNetworkModel]? { get }
    var likedIDs: [String]? { get }
    var authors: [String: String] { get }
    var sort: MyNFTViewModel.Sort? { get set }
    
    func checkStoredSort()
    func getMyNFTs(nftIDs: [String])
    func toggleLikeFromMyNFT(id: String)
}

final class MyNFTViewModel: MyNFTViewModelProtocol {
    var onChange: (() -> Void)?
    var onError: ((_ error: Error) -> Void)?
    private var networkClient: NetworkClient = DefaultNetworkClient()
    private(set) var profile: ProfileModel?
    private let dispatchGroup = DispatchGroup()
    
    var sort: Sort? {
        didSet {
            guard let sort else { return }
            myNFTs = applySort(by: sort)
        }
    }
    
    private(set) var myNFTs: [NFTNetworkModel]? {
        didSet {
            onChange?()
        }
    }
    
    private(set) var likedIDs: [String]? {
        didSet {
            onChange?()
        }
    }
    
    
    
    private(set) var authors: [String: String] = [:] {
        didSet {
            onChange?()
        }
    }
    
    init(networkClient: NetworkClient? = nil, profile: ProfileModel){
        if let networkClient = networkClient { self.networkClient = networkClient }
        self.profile = profile
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
                        self.myNFTs? = loadedNFTs
                    case .failure(let error):
                        self.onError?(error)
                        UIBlockingProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    
    func toggleLikeFromMyNFT(id: String) {
        guard var likedIDs = self.likedIDs else { return }
        if likedIDs.contains(id) {
            self.likedIDs = likedIDs.filter({ $0 != id })
        } else {
            likedIDs.append(id)
            self.likedIDs = likedIDs
        }
    }
    
    @objc
    private func unlikeNFTFromFavorites(notification: Notification) {
        let nftId = notification.object as? String
        self.likedIDs = likedIDs?.filter({ $0 != nftId })
    }
    
    private func getAuthors(nft: NFTNetworkModel) {
        networkClient.send(request: GetMyNFTRequest(id: nft.author, item: .author), type: AuthorNetworkModel.self) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let author):
                        self.authors.updateValue(author.name, forKey: author.id)
                        self.dispatchGroup.leave()
                    case .failure(let failure):
                        self.onError?(failure)
                        return
                    }
                }
        }
    }
    
    private func applySort(by value: Sort) -> [NFTNetworkModel] {
        guard let myNFTs = myNFTs else { return [] }
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
        if let sortOrder = UserDefaults.standard.data(forKey: "sortOrder") {
            let order = try? PropertyListDecoder().decode(MyNFTViewModel.Sort.self, from: sortOrder)
            sort = order
        }
        sort = .rating
    }
}

extension MyNFTViewModel {
    enum Sort: Codable {
        case price
        case rating
        case name
    }
}
