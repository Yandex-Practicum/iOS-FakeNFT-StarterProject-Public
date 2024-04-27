import Foundation

struct UsersModel: Decodable {
    
    let id: String
    let name: String
    let avatar: String
    let rating: String
    let website: String
    let nfts: [String]
    let description: String
    
    func getRating() -> Int {
        Int(rating) ?? 0
    }
}
