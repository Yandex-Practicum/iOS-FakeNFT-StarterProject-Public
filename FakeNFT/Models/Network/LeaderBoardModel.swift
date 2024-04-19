import Foundation

struct LeaderBoardModel: Decodable {
    let id: String
    let name: String
    let avatar: URL
    let countOfNft: Int
}
