import Foundation
import ProgressHUD

protocol EditingViewModelProtocol {
    var userProfile: UserProfile? { get }
    func observeUserProfileChanges(_ handler: @escaping (UserProfile?) -> Void)
    
    func viewDidLoad()
    func viewWillDisappear()
    
    func updateName(_ name: String)
    func updateDescription(_ description: String)
    func updateWebSite(_ website: String)
    
    func photoURLdidChanged(with url: URL)
}

final class EditingViewModel: EditingViewModelProtocol {
    @Observable
    private(set) var userProfile: UserProfile?
    private let profileService: ProfileService
    
    private let imageValidator: ImageValidatorProtocol
    
    init(profileService: ProfileService,
         imageValidator: ImageValidatorProtocol = ImageValidator()
    ) {
        self.profileService = profileService
        self.imageValidator = imageValidator
    }
    
    func observeUserProfileChanges(_ handler: @escaping (UserProfile?) -> Void) {
        $userProfile.observe(handler)
    }
    
    func viewDidLoad() {
        fetchUserProfile()
    }
    
    func updateName(_ name: String) {
        guard let currentProfile = userProfile else { return }
        userProfile = UserProfile(
            name: name,
            avatar: currentProfile.avatar,
            description: currentProfile.description,
            website: currentProfile.website,
            nfts: currentProfile.nfts,
            likes: currentProfile.likes,
            id: currentProfile.id
        )
    }
    
    func updateDescription(_ description: String) {
        guard let currentProfile = userProfile else { return }
        userProfile = UserProfile(
            name: currentProfile.name,
            avatar: currentProfile.avatar,
            description: description,
            website: currentProfile.website,
            nfts: currentProfile.nfts,
            likes: currentProfile.likes,
            id: currentProfile.id
        )
    }
    
    func updateWebSite(_ website: String) {
        guard let currentProfile = userProfile else { return }
        userProfile = UserProfile(
            name: currentProfile.name,
            avatar: currentProfile.avatar,
            description: currentProfile.description,
            website: website,
            nfts: currentProfile.nfts,
            likes: currentProfile.likes,
            id: currentProfile.id
        )
    }
    
    func viewWillDisappear() {
        guard let userProfile = userProfile else { return }
        profileService.updateProfile(with: userProfile) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let updatedProfile):
                self.userProfile = updatedProfile
            case .failure(let error):
                //ToDo: - Уведомление об ошибке
                print(error)
            }
        }
    }
    
    func photoURLdidChanged(with url: URL) {
        imageValidator.isValidImageURL(url) { [weak self] isValid in
            guard let self = self else { return }
            if isValid,
               let currentProfile = self.userProfile {
                self.userProfile = UserProfile(
                    name: currentProfile.name,
                    avatar: url.absoluteString,
                    description: currentProfile.description,
                    website: currentProfile.website,
                    nfts: currentProfile.nfts,
                    likes: currentProfile.likes,
                    id: currentProfile.id
                )
            } else {
                // ToDo: Уведомьте пользователя, что URL не является действительным изображением.
            }
        }
    }
    
    private func fetchUserProfile() {
        ProgressHUD.show(NSLocalizedString("ProgressHUD.loading", comment: ""))
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userProfile):
                self.userProfile = userProfile
            case .failure(let error):
                //ToDo: - Уведомление об ошибке
                print(error)
            }
        }
    }
}

