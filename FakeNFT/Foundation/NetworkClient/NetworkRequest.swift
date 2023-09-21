import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct DefaultNetworkRequest: NetworkRequest {
    var endpoint: URL?
    let dto: Encodable?
    let httpMethod: HttpMethod
}

//struct PaymentNetworkRequest: NetworkRequest {
//    var endpoint: URL? {
//        
//    }
//    let id: String
//    let httpMethod: HttpMethod
//}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}
