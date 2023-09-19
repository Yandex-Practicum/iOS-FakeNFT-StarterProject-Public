import Foundation

struct ProfileNetworkModel: Codable {
    let avatar: String
    let description, id, name: String
    let nfts: [String]
    let likes: [String]
    let website: String
}
