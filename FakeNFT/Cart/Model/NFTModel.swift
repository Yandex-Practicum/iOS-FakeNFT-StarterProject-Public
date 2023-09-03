import UIKit

struct NFTModel: Hashable {
    let id: String
    let name: String
    let price: Float
    let rating: Int
    let images: [URL]
    
    init(model: NFTServerModel) {
        id = model.id
        name = model.name
        images = model.images
        price = model.price
        rating = model.rating
    }
}

struct NFTServerModel: Decodable {
    let id: String
    let name: String
    let images: [URL]
    let price: Float
    let rating: Int
}
