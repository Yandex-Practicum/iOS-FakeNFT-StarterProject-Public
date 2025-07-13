import Foundation

struct CartItemsRequest: NetworkRequest {
    var endpoint: URL?
    var token: String?
    
    init() {
        self.endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
        self.token = RequestConstants.token
    }
}
