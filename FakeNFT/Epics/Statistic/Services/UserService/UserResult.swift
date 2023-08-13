import Foundation

struct UserResult: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}

extension UserResult {
    func toUser() -> User {
        let avatarURL = URL(string: avatar)
        let nftCount = String(nfts.count)

        return User(
            ranking: rating,
            avatarURL: avatarURL,
            username: name,
            nftCount: nftCount,
            description: description,
            nfts: nfts.convertToInts()
        )
    }
}
