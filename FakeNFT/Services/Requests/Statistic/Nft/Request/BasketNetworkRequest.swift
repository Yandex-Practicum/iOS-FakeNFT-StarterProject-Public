import Foundation

struct BasketRequest: NetworkRequest {
    
    var dto: Encodable?
    var httpMethod: HttpMethod = .put
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
