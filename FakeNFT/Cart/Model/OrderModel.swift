import Foundation

struct OrderModel: Decodable, Encodable {
    let nfts: [String]
    let id: String
}
