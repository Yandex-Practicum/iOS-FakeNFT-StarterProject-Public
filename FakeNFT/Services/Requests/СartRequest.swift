import Foundation

struct CartRequest: NetworkRequest {
    var dto: (any Dto)?
    
    let orderId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)")
    }
    var httpMethod: HttpMethod { .get }
}

struct CartDeleteRequest: NetworkRequest {
    var dto: (any Dto)?
     
    
    let orderId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)")
    }
    
    var httpMethod: HttpMethod { .put }
}
