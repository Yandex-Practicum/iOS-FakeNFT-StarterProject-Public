import Foundation

struct StatisticsNFTModel: Decodable {
    let createdAt: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case name = "name"
        case images = "images"
        case rating = "rating"
        case description = "description"
        case price = "price"
        case author = "author"
        case id = "id"
    }
}
