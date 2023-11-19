import Foundation

// struct Nft: Decodable {
//    let id: String
//    let images: [URL]
// }

struct Nft: Decodable {
    let id: String
    let images: [URL]
    let rating: Int
    let name: String
    let price: Float
}
