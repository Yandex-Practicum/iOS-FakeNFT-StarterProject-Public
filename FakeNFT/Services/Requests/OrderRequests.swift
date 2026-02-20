import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? { URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1") }
    var httpMethod: HttpMethod { .get }
}

struct UpdateOrderRequest: NetworkRequest {
    let nfts: [String]
    var endpoint: URL? { URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1") }
    var httpMethod: HttpMethod { .put }
    var dto: Dto? { OrderDto(nfts: nfts) }
}

private struct OrderDto: Dto {
    let nfts: [String]

    func asDictionary() -> [String : String] {
        [
            "nfts": nfts.joined(separator: ",")
        ]
    }
}

