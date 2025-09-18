import Foundation

struct CartResponse: Decodable {
    let id: String
    let nfts: [String]
}

struct NFTModel: Decodable {
    let id: String
    let name: String
    let images: [String]
    let rating: Double
    let price: Float
}
