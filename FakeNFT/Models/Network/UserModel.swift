import Foundation

struct UserModel: Codable {
    let avatar: String
    let description, id, name: String
    let nfts: [String]
    let rating: String
    let website: String
}

typealias User = [UserModel]
