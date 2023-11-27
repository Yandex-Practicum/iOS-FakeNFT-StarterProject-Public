import Foundation

// struct Nft: Decodable {
//    let id: String
//    let images: [URL]
// }

struct Nft: Codable {
    let id: String
    let images: [URL]
<<<<<<< HEAD
    let name: String
    let rating: Int
=======
    let rating: Int
    let name: String
>>>>>>> catalogue-epic
    let price: Float
}
