import Foundation

struct NFTRequest: NetworkRequest {
    var token: String?
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
