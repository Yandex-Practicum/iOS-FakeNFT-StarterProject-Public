import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var queryParameters: [String: String]? { get }
    var httpMethod: HttpMethod { get }
    var httpBody: Data? { get }
}

// default values
extension NetworkRequest {
    var queryParameters: [String: String]? { nil }
    var httpMethod: HttpMethod { .get }
    var httpBody: Data? { nil }
}
