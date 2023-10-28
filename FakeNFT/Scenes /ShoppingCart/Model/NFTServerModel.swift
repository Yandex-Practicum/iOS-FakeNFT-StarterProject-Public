import UIKit

struct NFTServerModel: Decodable {
    let id: String
    let name: String
    let images: [URL]
    let price: Float
    let rating: Int
}
