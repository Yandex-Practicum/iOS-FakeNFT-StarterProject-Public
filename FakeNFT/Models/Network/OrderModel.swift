import Foundation

struct OrderModel: Codable {
    let nfts: [String]
    let id: String
}

typealias Order = [OrderModel]
