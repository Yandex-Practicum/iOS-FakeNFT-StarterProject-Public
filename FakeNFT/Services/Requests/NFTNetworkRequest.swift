import Foundation

struct NFTNetworkRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Encodable?
}
