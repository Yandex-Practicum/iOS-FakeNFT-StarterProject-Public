import UIKit

struct NFTServerModel: Decodable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let price: Double
}

struct NFTCartModel: Hashable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Rating
    let price: Double
    
    init(serverModel: NFTServerModel) {
        id = serverModel.id
        name = serverModel.name
        images = serverModel.images
        rating = Rating(rawValue: serverModel.rating) ?? .zero
        price = serverModel.price
    }
}
