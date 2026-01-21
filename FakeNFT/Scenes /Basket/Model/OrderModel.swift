import Foundation

struct OrderModel: Decodable {
    let id: String
    let nfts: [String]
}
