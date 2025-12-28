import Foundation

struct User: Codable {
    let id: String
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let rating: String
    
    var nftAmount: Int {
        nfts.count
    }
}
