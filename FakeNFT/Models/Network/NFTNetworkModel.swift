import Foundation

struct NFTNetworkModel: Codable {
    let author: String
    let createdAt: String
    let rating: Int
    let price: Float
    let description, id, name: String
    let images: [String]
}
