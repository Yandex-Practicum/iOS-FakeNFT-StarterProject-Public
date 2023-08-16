import UIKit.UIImage

struct NFTCartCellViewModel: Equatable {
    let id: String
    let name: String
    let image: UIImage?
    let rating: Int
    let price: Double
}

typealias OrderViewModel = [NFTCartCellViewModel]
