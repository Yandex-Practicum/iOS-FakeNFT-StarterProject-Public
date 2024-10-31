import Foundation

final class PutOrderRequest: NetworkRequest {
    var dto: (any Dto)?
    var httpMethod: HttpMethod = .put
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    init(nftIds: [String]) {
        self.dto = PutOrderDto(nftIds: nftIds)
    }
}

final class PutOrderDto: Dto {
    func asDictionary() -> [String : String] {
        var dictionary: [String: String] = [:]
        for (index, nft) in nftsIds.enumerated() {
            dictionary["nfts"] = nft
        }
        return dictionary
    }
    
    var nftsIds: [String]
    
    init(nftIds: [String]) {
        self.nftsIds = nftIds
    }
}
