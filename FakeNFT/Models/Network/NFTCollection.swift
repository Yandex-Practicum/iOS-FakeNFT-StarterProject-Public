import Foundation

struct NFTCollection: Decodable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
    
    var nftCount: Int {
        nfts.count
    }
}
