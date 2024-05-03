import Foundation

struct User: Codable {
    let id: String
    let name: String
    let avatar: URL
    let nfts: [String]
    let rating: String
    var ratingValue: Float { return Float(rating) ?? 0.0 }
}

struct UserCellModel {
    let id: String
    let name: String
    let avatar: URL
    let nfts: [String]
    var ratingValue: Float
    var ratingPosition: Int
}
