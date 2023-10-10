import Foundation

struct OrderNetworkModel: Codable {
    let nfts: [String]
    let id: String
}

typealias OrderNet = [OrderNetworkModel]
