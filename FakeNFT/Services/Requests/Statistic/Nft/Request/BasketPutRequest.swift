import Foundation

struct BasketPutRequest: NetworkRequest {
    
    let basket: Basket
    var dto: Encodable?
    var httpMethod: HttpMethod = .put
    var endpoint: URL? {
        var urlComponents = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
        var components: [URLQueryItem] = []
        
        for nft in basket.nfts {
            components.append(URLQueryItem(name: "nfts", value: nft))
        }
        
        urlComponents?.queryItems = components
        return urlComponents?.url
    }
    
    var isUrlEncoded: Bool {
        return true
    }
}
