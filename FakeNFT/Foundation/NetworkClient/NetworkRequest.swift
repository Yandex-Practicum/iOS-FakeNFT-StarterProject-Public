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
    var body: Data? { get }
    var httpMethod: HttpMethod { get }
}

// default values
extension NetworkRequest {
    var queryParameters: [String: String]? { nil }
    var body: Data? { nil }
    var httpMethod: HttpMethod { .get }
}
