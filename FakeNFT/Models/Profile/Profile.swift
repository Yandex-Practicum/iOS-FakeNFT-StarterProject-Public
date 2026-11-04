import Foundation

struct Profile: Codable {
    let id: String
    let name: String
    let description: String?
    let website: String?
    let avatar: String
    let nfts: [String]
    let likes: [String]
}
