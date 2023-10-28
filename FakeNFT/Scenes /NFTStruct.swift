import UIKit

struct NFT: Hashable {
    let id: UUID
    let name: String
    let picture: UIImage
    let price: Float
    let rating: Int
}
