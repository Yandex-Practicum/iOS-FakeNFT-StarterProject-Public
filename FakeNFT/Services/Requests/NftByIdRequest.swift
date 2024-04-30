import Foundation

struct NFTRequest: NetworkRequest {

    let id: String
    var isUrlEncoded: Bool { false }
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
