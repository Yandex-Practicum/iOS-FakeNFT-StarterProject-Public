import Foundation

protocol UserCardProtocol {
    
    func getAvatar() -> URL?
    func getName() -> String
    func getDescription() -> String
    func getWebsiteUser() -> URL?
    func getCountOfNft() -> String
}

final class UserCardFabric {
    
    private let mockData = MockData.shared
    private var profileUser: UsersModel
    
    init(with profileUser: UsersModel) {
        self.profileUser = profileUser
    }
}

extension UserCardFabric: UserCardProtocol {
    
    func getNfts() -> [String]? {
        
        profileUser.nfts
    }
    
    func getAvatar() -> URL? {
        
        URL(string: profileUser.avatar)
    }
    
    func getName() -> String {
        
        profileUser.name
    }
    
    func getDescription() -> String {
        
        profileUser.description
    }
    
    func getWebsiteUser() -> URL? {
        
        URL(string: profileUser.website)
    }
    
    func getCountOfNft() -> String {
        
        profileUser.rating
    }
}
