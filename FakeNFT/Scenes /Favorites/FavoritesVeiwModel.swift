import UIKit

final class FavoritesViewModel {
    
    // MARK: - Properties
    var onChange: (() -> Void)?
    var onError: (() -> Void)?
    
    private let networkClient = DefaultNetworkClient()

    private(set) var likedNFTs: [NFTNetworkModel]? {
        didSet {
            onChange?()
        }
    }

    // MARK: - Lifecycle
    init(likedIDs: [String]){
        self.likedNFTs = []
//        getMyNFTs(nftIDs: nftIDs)
    }
}
