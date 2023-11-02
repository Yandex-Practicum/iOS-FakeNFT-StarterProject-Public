import Foundation

struct UserModel {
    let name: String
    let avatar: URL
    let description: String
    let website: URL
    let nfts: [String]
    let rating: Int
    let id: String
}

extension UserModel {
    init(serverModel: ServerUserModel) {
        name = serverModel.name
        avatar = serverModel.avatar
        description = serverModel.description
        website = serverModel.website
        nfts = serverModel.nfts
        rating = Int(serverModel.rating) ?? 0
        id = serverModel.id
    }
}
