import Foundation

final class ProfileEditPresenter: ProfileEditPresenterProtocol {
    // MARK: - ProfileEditPresenterProtocol properties
    
    var profileChanged: Bool {
        return profile.name != name ||
        profile.avatar != avatar ||
        profile.description != description ||
        profile.website.absoluteString != website
    }
    var newProfile: ProfileResponseModel {
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
    
    // MARK: - Private properties
    
    private let profile: EditableProfileModel
    private var name: String
    private var avatar: String
    private var description: String
    private var website: String
    
    // MARK: - Life cycle
    
    init(editableProfile: EditableProfileModel) {
        profile = editableProfile
        name = editableProfile.name
        avatar = editableProfile.avatar
        description = editableProfile.description
        website = editableProfile.website.absoluteString
    }
    
    // MARK: - ProfileEditPresenterProtocol
    
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
    
    func calculateViewYOffset(textFieldY: CGFloat, viewHeight: CGFloat, keyboardHeight: CGFloat) -> CGFloat {
        if viewHeight == 627 {
            return keyboardHeight - 20
        } else if viewHeight <= 752 {
            return (keyboardHeight - (viewHeight - textFieldY)) + 10
        } else {
            return (keyboardHeight - (viewHeight - textFieldY)) + 60
        }
    }
}
