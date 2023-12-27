
import Foundation

protocol EditingProfilePresenterProtocol {
    var profile: ProfileModelUI? { get }
    var newLinkPhoto: String { get set}
    var view: EditingProfileViewControllerProtocol? { get set }
    var completionHandler: ProfileCompletion? { get set }
    func viewWillDisappear(name: String, description: String, website: String)
    func viewDidLoad()
}

final class EditingProfilePresenter: EditingProfilePresenterProtocol {
    
    var profile: ProfileModelUI?
    private var profileService: ProfileServiceProtocol?
    var newLinkPhoto: String
    var completionHandler: ProfileCompletion?
    weak var view: EditingProfileViewControllerProtocol?
    
    init(profile: ProfileModelUI?,
         profileService: ProfileServiceProtocol?,
         completionHandler: ProfileCompletion?
    ) {
        self.profile = profile
        self.profileService = profileService
        newLinkPhoto = profile?.urlAvatar ?? ""
        self.completionHandler = completionHandler
    }
    
    func viewWillDisappear(name: String, description: String, website: String) {
        saveProfile(newProfile: ProfileModelUI(
            id: profile?.id ?? "",
            name: name,
            avatar: profile?.avatar ?? Data(),
            urlAvatar: newLinkPhoto,
            description: description,
            website: website,
            nfts: profile?.nfts ?? [],
            likes: profile?.likes ?? []))
    }
    
    func viewDidLoad() {
        guard let profile else { return }
        view?.updateUI(profile: profile)
    }
    
    private func saveProfile(newProfile: ProfileModelUI) {
        guard let profile else {return}
        
        let name = newProfile.name == profile.name ? nil : newProfile.name
        let avatar = newProfile.urlAvatar == profile.urlAvatar ? nil : newProfile.urlAvatar
        let description = newProfile.description == profile.description ? nil : newProfile.description
        let website = newProfile.website == profile.website ? nil : newProfile.website
        
        let profileModelEditing = ProfileModelEditing(name: name,
                                                      avatar: avatar,
                                                      description: description,
                                                      website: website)
        
        profileService?.saveProfile(
            profileEditing: profileModelEditing,
            completion: completionHandler)
    }
    
}
