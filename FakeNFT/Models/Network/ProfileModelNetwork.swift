
import Foundation
 
struct ProfileModelNetwork: Codable {
    let id: String
    let name: String
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]
    let likes: [String]
}
