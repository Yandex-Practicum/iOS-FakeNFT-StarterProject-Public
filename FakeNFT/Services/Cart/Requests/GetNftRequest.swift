import Foundation

struct GetNftRequest: NetworkRequest {
    var endpoint: URL?
    var token: String?
    
    init(id: String) {
        self.endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
        self.token = RequestConstants.token
    }
}
