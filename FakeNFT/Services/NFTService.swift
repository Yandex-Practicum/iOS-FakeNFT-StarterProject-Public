import Foundation

final class NFTService {
    static let shared = NFTService(networkHelper: NetworkServiceHelper(networkClient: DefaultNetworkClient()))
    
    private let networkHelper: NetworkServiceHelper
    
    init(networkHelper: NetworkServiceHelper) {
        self.networkHelper = networkHelper
    }
    
    func fetchNFT(nftID: String, completion: @escaping (Result<NFT, Error>) -> Void) {
        let request = FetchNFTNetworkRequest(nftID: nftID)
        networkHelper.fetchData(request: request, type: NFT.self, completion: completion)
    }
    
    func fetchAuthor(authorID: String, completion: @escaping (Result<Author, Error>) -> Void) {
        let request = FetchAuthorNetworkRequest(authorID: authorID)
        networkHelper.fetchData(request: request, type: Author.self, completion: completion)
    }
    
    func stopAllTasks() {
        networkHelper.stopAllTasks()
    }
}
