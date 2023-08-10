import Foundation

enum NetworkConstants {
    static let baseURL = URL(string: "https://64c51750c853c26efada7c53.mockapi.io/api/v1")!
    static let profileEndpoint = "profile/1"
}

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
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}
