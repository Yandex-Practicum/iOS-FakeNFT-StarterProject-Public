import Foundation

struct NftDTO: Decodable {
    let id: String
    let name: String
    let rating: Int
    let price: Double
    let description: String
    let author: URL?
    let images: [URL]
}
