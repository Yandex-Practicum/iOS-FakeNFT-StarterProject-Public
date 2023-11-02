import Foundation

struct StatisticsTableViewCellModel {
    let number: String
    let profilePhoto: URL
    let profileName: String
    let profileNFTCount: Int
}

extension StatisticsTableViewCellModel {
    init(userModel: UserModel) {
        number = String(userModel.rating)
        profilePhoto = userModel.avatar
        profileName = userModel.name
        profileNFTCount = userModel.nfts.count
    }
}
