import Foundation

struct NFTItemModel: Decodable {
    let id: String
    let createdAt: Date
    let name: String
    let images: [NFTImage]
    let rating: Int
    let description: String
    let price: Double
    let author: String
}

typealias NFTItemResponse = [NFTItemModel]
typealias NFTImage = String
