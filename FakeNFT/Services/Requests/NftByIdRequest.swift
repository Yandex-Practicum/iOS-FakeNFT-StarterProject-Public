import Foundation

struct NFTRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
    var dto: Dto?
}

struct NftListRequest: NetworkRequest {
    var endpoint: URL? { URL(string: "\(RequestConstants.baseURL)/api/v1/nft") }
    var dto: Dto?
}

struct NftByIdRequest: NetworkRequest {
    let id: String
    var endpoint: URL? { URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)") }
    var dto: Dto? = nil
}

struct CatalogsListRequest: NetworkRequest {
    var endpoint: URL? { URL(string: "\(RequestConstants.baseURL)/api/v1/collections") }
    var dto: Dto?
}

struct CatalogByIdRequest: NetworkRequest {
    let id: String
    var endpoint: URL? { URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(id)") }
    var dto: Dto? = nil
}
