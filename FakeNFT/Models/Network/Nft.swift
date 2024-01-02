import Foundation

struct Nft: Decodable {
    let id: String
    let images: [URL]
    let name: String
    let rating: Int
    let price: Float
}
