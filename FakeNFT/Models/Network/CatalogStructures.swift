import UIKit

struct Catalog: Decodable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let website: String
    let id: String
}



struct Favorites: Codable {
    let likes: [String]
}

struct Orders: Codable {
    let nfts: [String]
    let id: String
}
