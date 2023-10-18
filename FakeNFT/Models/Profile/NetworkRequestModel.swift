import Foundation

struct NetworkRequestModel: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Encodable?
}
