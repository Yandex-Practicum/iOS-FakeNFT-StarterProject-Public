import Foundation

struct UserResponse: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}

typealias UsersResponse = [UserResponse]

extension UserResponse {
    func convert() -> User {
        return User(name: self.name,
                    avatar: self.avatar,
                    rating: self.rating,
                    id: self.id)
    }
}
