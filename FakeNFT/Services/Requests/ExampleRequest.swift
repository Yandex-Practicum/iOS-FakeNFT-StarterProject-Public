import Foundation

struct ExampleRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://65450baa5a0b4b04436d87e6.mockapi.io/api/v1/:endpoint")
    }
}

struct NFTNetworkRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Encodable?
}
