import Foundation

enum EditableParameter {
    case name
    case description
    case site
    case imageUrl
}

final class ProfileEditPresenter: ProfileEditPresenterProtocol {
    // MARK: - Private properties
    
    private let profile: EditableProfileModel
    private var name: String
    private var avatar: String
    private var description: String
    private var website: String
    
    init(editableProfile: EditableProfileModel) {
        profile = editableProfile
        name = editableProfile.name
        avatar = editableProfile.avatar
        description = editableProfile.description
        website = editableProfile.website.absoluteString
    }
    
    func change(parameter: EditableParameter, with text: String) {
        switch parameter {
        case .name:
            name = text
        case .description:
            description = text
        case .site:
            website = text
        case .imageUrl:
            avatar = text
        }
    }
    
    func isProfileChanged() -> Bool {
        if profile.name == name &&
            profile.avatar == avatar &&
            profile.description == description &&
            profile.website.absoluteString == website
        {
            return false
        } else {
            return true
        }
    }
    
    func getNewProfile() -> ProfileResponseModel {
        return ProfileResponseModel(
            name: name,
            avatar: avatar,
            description: description,
            website: URL(string: website) ?? profile.website,
            nfts: profile.nfts,
            likes: profile.likes,
            id: profile.id
        )
    }
}
