import Foundation

protocol UserCardProtocol {
    
    func getAvatar(with id: String) -> URL
    func getName(with id: String) -> String
    func getDescription(with id: String) -> String
    func getWebsiteUser(with id: String) -> URL
    func getCountOfNft(with id: String) -> Int
}

final class UserCardFabric {
    
    private let mockData = MockData.shared
    private var profileUser: ProfileModel
    
    init(profileUser: ProfileModel) {
        self.profileUser = profileUser
    }
    
    convenience init(with id: String) {
        let user = MockData.shared.userCardInfo.first { model in
            model.id == id
        }
        self.init(profileUser: user!)
    }
}

extension UserCardFabric: UserCardProtocol {
    
//    func getProfileUser(with id: String) -> ProfileModel {
//        //TODO: get profile user from network client
//    }
    
    func getAvatar(with id: String) -> URL {
        
        profileUser.avatar
    }
    
    func getName(with id: String) -> String {
        
        profileUser.name
    }
    
    func getDescription(with id: String) -> String {
        
        profileUser.description
    }
    
    func getWebsiteUser(with id: String) -> URL {
        
        profileUser.website
    }
    
    func getCountOfNft(with id: String) -> Int {
        
        profileUser.countOfNft
    }
}
