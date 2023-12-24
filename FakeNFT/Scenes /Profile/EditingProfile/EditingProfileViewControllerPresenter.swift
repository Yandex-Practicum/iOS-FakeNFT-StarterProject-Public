
import Foundation

protocol EditingProfilePresenterProtocol {
    var profile: ProfileModelUI? { get }
    var profileService: ProfileServiceProtocol { get }
    func saveProfile(newProfile: ProfileModelUI, completion: @escaping ProfileCompletion)
}

final class EditingProfilePresenter: EditingProfilePresenterProtocol {
    var profile: ProfileModelUI?
    var profileService: ProfileServiceProtocol
    
    init(profile: ProfileModelUI?, profileService: ProfileServiceProtocol) {
        self.profile = profile
        self.profileService = profileService
    }
    
    func saveProfile(newProfile: ProfileModelUI, completion: @escaping ProfileCompletion) {
        guard let profile else {return}
        
        let name = newProfile.name == profile.name ? nil : newProfile.name
        let avatar = newProfile.urlAvatar == profile.urlAvatar ? nil : newProfile.urlAvatar
        let description = newProfile.description == profile.description ? nil : newProfile.description
        let website = newProfile.website == profile.website ? nil : newProfile.website
        
        let profileModelEditing = ProfileModelEditing(name: name,
                                                      avatar: avatar,
                                                      description: description,
                                                      website: website)
        
        profileService.saveProfile(profileEditing: profileModelEditing, completion: completion)
    }
    
}
