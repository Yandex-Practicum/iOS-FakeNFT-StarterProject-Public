import UIKit

struct NFTModel: Codable {
    let id: String
    let name: String
    let price: Float
    let rating: Int
    let images: [URL]
}

