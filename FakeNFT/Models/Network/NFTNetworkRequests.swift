import Foundation

struct FetchNFTNetworkRequest: NetworkRequest {
    let nftID: String
    
    var endpoint: URL? {
        URL(string: "https://651ff0d9906e276284c3c20a.mockapi.io/api/v1/nft/\(nftID)")
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    init(nftID: String) {
        self.nftID = nftID
    }
}

struct FetchAuthorNetworkRequest: NetworkRequest {
    let authorID: String

    var endpoint: URL? {
        URL(string: "https://651ff0d9906e276284c3c20a.mockapi.io/api/v1/users/\(authorID)")
    }

    var httpMethod: HttpMethod {
        return .get
    }
}
