import Foundation

final class NFTServiceProfile {
    static let shared = NFTServiceProfile(networkHelper: NetworkServiceHelper(networkClient: DefaultNetworkClient()))

    private let networkHelper: NetworkServiceHelper

    init(networkHelper: NetworkServiceHelper) {
        self.networkHelper = networkHelper
    }

    func fetchNFT(nftID: String, completion: @escaping (Result<NFTProfile, Error>) -> Void) {
        let request = FetchNFTNetworkRequest(nftID: nftID)
        networkHelper.fetchData(request: request, type: NFTProfile.self, completion: completion)
    }

    func fetchAuthor(authorID: String, completion: @escaping (Result<Author, Error>) -> Void) {
        let request = FetchAuthorNetworkRequest(authorID: authorID)
        networkHelper.fetchData(request: request, type: Author.self, completion: completion)
    }

    func stopAllTasks() {
        networkHelper.stopAllTasks()
    }
}
