import Foundation

struct CollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    var dto: Dto?
    
    var headers: [String: String]? {
        return [
            "X-API-KEY": RequestConstants.token,
            "Content-Type": "application/json"
        ]
    }
}
