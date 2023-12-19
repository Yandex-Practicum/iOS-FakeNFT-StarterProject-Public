import Foundation

struct Author: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: URL
    let nfts: [String]
    let rating: String
    let id: String
}
