
import Foundation

struct ProfileModelEditing {
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let likes: [String]
    
    init(name: String? = nil,
         avatar: String? = nil,
         description: String? = nil,
         website: String? = nil,
         likes: [String] = [])
    {
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.likes = likes
    }
}
