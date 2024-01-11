import Foundation

struct Nft: Codable {
    let id: String
    let images: [URL]
    let name: String
    let rating: Int
    let price: Float
}
