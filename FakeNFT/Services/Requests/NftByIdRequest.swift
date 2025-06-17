import Foundation

struct NFTRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(NetworkConstants.RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
    var dto: Dto?
}
