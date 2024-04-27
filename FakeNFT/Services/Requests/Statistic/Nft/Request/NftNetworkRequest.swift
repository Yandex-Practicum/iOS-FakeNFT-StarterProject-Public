import Foundation

struct NftNetworkRequest: NetworkRequest {
    
    var id: String
    
    var httpMethod: HttpMethod = .get
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
