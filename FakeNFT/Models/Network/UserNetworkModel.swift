import Foundation

struct UserNetworkModel: Codable {
    let avatar: String
    let description, id, name: String
    let nfts: [String]
    let rating: String
    let website: String
}

typealias UserNet = [UserNetworkModel]
