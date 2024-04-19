import Foundation

struct ProfileModel: Decodable {
    let id: String
    let name: String
    let avatar: URL
    let description: String
    let website: URL
    let countOfNft: Int
}
