import Foundation

public struct NFTItemModel: Decodable {
    let id: String
    let createdAt: Date
    let name: String
    let images: [NFTImage]
    let rating: Int
    let description: String
    let price: Double
    let author: String

    public init(
        id: String,
        createdAt: Date,
        name: String,
        images: [NFTImage],
        rating: Int,
        description: String,
        price: Double,
        author: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.images = images
        self.rating = rating
        self.description = description
        self.price = price
        self.author = author
    }
}

public typealias NFTItemResponse = [NFTItemModel]
public typealias NFTImage = String
