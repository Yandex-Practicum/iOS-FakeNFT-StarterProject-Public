import Foundation

enum NFTType {
    case nft, author
}

struct GetMyNFTRequest: NetworkRequest {
    private let id: String
    private let item: NFTType
    
    init(id: String, item: NFTType) {
        self.id = id
        self.item = item
    }
    
    var endpoint: URL? {
        if  item == .author {
            return NetworkConstants.baseURL.appendingPathComponent("/users/\(id)")
        } else {
            return NetworkConstants.baseURL.appendingPathComponent("/nft/\(id)")
        }
    }
}


