import UIKit

struct NFTModel: Hashable {
    let id: UUID
    let name: String
    let price: Float
    let rating: Int
    let image: URL
}

struct MockNFTModel: Hashable {
    let id: UUID
    let name: String
    let price: Float
    let rating: Int
    let image: UIImage
}
