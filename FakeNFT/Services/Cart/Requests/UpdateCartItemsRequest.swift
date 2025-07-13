import Foundation

struct UpdateCartItemsRequest: NetworkRequest {
    var endpoint: URL?
    var token: String?
    var httpMethod: HttpMethod
    var dto: (any Encodable)?
    
    init(dto: Encodable) {
        self.endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
        self.token = RequestConstants.token
        self.dto = dto
        self.httpMethod = .put
    }
}
