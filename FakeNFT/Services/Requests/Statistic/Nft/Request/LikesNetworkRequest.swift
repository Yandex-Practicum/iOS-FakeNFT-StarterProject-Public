import Foundation

struct LikesRequest: NetworkRequest {
    
    var dto: Encodable?
    var httpMethod: HttpMethod = .put
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}
