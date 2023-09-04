import Foundation

struct NFTsCollectionModel: Codable {
    let author: String
    let cover: String
    let createdAt: Date
    let description, id, name: String
    let nfts: [String]
    
    var nameAndNFTsCount: String {
        name + "(\(nfts.count))"
    }
}

typealias NFTsCollection = [NFTsCollectionModel]
