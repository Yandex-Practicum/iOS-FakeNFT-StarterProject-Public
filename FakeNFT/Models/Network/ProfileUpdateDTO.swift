import Foundation

struct ProfileUpdateDTO: Encodable {
    let name: String
    let description: String
    let website: String
    let likes: [String]

    init(from userProfile: UserProfileModel) {
        self.name = userProfile.name
        self.description = userProfile.description
        self.website = userProfile.website
        self.likes = userProfile.likes
    }
}
