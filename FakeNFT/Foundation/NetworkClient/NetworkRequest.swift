import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
}

// default values
extension NetworkRequest {
    var baseEndpoint: String { "https://64e794a7b0fd9648b7902456.mockapi.io/api/v1/" }
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}
