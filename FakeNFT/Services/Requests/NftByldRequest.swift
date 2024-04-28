import Foundation

struct NFTRequest: NetworkRequest {
    
    var requestId: String {
        return "NFTRequest\(self.id)"
    }
    
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
