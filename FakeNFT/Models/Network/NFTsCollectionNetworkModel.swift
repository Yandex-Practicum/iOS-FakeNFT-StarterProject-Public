import Foundation

struct NFTsCollectionModel: Codable {
    let author: String
    let cover: String?
    let createdAt: String
    let description, id, name: String
    let nfts: [String]
    
    var nameAndNFTsCount: String {
        name + "(\(nfts.count))"
    }
    
    init(with collection: NFTsCollectionModel) {
        self.author = collection.author
        self.cover = collection.cover
        self.createdAt = collection.createdAt
        self.description = collection.description
        self.id = collection.id
        self.name = collection.name
        self.nfts = collection.nfts
    }
}

typealias NFTsCollectionNet = [NFTsCollectionModel]
