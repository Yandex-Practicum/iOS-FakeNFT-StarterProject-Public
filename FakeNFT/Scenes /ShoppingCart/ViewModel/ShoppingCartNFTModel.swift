import UIKit

struct ShoppingCartNFTModel: Hashable {
    let id: String
    let name: String
    let images: [URL]
    let price: Float
    let rating: Int
}

extension ShoppingCartNFTModel {
    init(serverModel: NFTServerModel) {
        id = serverModel.id
        name = serverModel.name
        images = serverModel.images
        price = serverModel.price
        rating = serverModel.rating
    }
}
