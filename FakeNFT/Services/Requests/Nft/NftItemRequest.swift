import Foundation

struct NFTItemRequest: NetworkRequest {
    let nftId: String
    var httpMethod: HttpMethod = .get

    var endpoint: URL? {
        let api = AppConstants.Api.self
        var components = URLComponents(string: api.defaultEndpoint)
        let apiVersion = api.version
        let nftController = api.Nft.controller
        components?.path = "\(apiVersion)/\(nftController)/\(nftId)"
        return components?.url
    }
}
