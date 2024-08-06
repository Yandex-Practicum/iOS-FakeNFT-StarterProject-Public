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
  var token: String? { get }
  var isUrlEncoded: Bool { get }
}

// default values
extension NetworkRequest {
  var httpMethod: HttpMethod { .get }
  var dto: Encodable? { nil }
  var token: String? { Token.token }
  var isUrlEncoded: Bool { false }
}

enum Token {
  static let token = "edfc7835-684c-4eaf-a7b3-26ecea542ca3"
}
