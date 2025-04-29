import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum HttpStrings: String {
    case order = "/api/v1/orders/1"
    case currencies = "/api/v1/currencies"
    case currency = "/api/v1/currencies/1"
    case payment = "/api/v1/orders/1/payment/"
    case nfts = "/api/v1/nft"
}


protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Dto? { get }
}

protocol Dto {
    func asDictionary() -> [String: String]
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}
