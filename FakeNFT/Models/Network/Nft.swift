import Foundation

struct Nft: Decodable {
    let id: String
    let images: [URL]
    let author: String
    let createdAt: String
    let rating: Int
    let description: String
    let price: Float
    let name: String
}
