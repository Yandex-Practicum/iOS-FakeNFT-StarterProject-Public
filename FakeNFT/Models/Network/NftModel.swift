import Foundation

struct NftModel: Decodable {
    
    let id: String
    let name: String
    let images: [URL?]
    let price: Float
    let rating: Int
    let createdAt: String
    let description: String
    let author: String
}
