import Foundation

struct NFTsCollectionNetworkModel: Codable {
    let author: String
    let cover: String?
    let createdAt: String
    let description, id, name: String
    let nfts: [String]
    
    var nameAndNFTsCount: String {
        name + " (\(nfts.count))"
    }
}

