import Foundation

struct User: Decodable {
    let name: String
    let avatar: URL?
    let description: String
    let website: URL?
    let nfts: [String]?
    let rating: String?
    let id: String
}
