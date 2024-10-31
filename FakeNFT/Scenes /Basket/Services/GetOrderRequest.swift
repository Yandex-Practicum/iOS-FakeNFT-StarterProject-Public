import Foundation

final class GetOrderRequest: NetworkRequest {
    var dto: (any Dto)?
    var httpMethod: HttpMethod
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    init(httpMethod: HttpMethod) {
        self.httpMethod = httpMethod
    }
}
