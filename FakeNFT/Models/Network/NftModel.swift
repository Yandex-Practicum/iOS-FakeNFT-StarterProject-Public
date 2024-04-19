import Foundation

struct NftModel: Decodable {
    let name: String
    let avatar: URL
    let price: String
    let rating: Int
}
