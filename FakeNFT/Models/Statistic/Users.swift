import Foundation

struct User: Codable {
    let name: String
    let avatar: String
    let rating: String
    let description: String
    let website: String
    let id: String
    let nfts: [String]
}

typealias Users = [User]
