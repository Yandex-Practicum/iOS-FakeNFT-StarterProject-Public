import Foundation

struct ProfileResponseModel: Codable, Equatable {
    let name: String
    let avatar: String
    let description: String
    let website: URL
    let nfts: [String]
    let likes: [String]
    let id: String
}
