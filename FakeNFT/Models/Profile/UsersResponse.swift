import Foundation

struct UserResponse: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
    
    func convert() -> User {
        User(name: self.name,
             avatar: self.avatar,
             rating: self.rating,
             id: self.id)
    }
}

typealias UsersResponse = [UserResponse]
