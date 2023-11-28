import Foundation
import ProgressHUD

protocol ProfileViewModelProtocol {
    var userProfile: UserProfile? { get }
    func observeUserProfileChanges(_ handler: @escaping (UserProfile?) -> Void)

    func viewDidLoad()
    func userWillcloseViewController()

    func updateName(_ name: String)
    func updateDescription(_ description: String)
    func updateWebSite(_ website: String)
    func photoURLdidChanged(with url: URL)
}

final class ProfileViewModel: ProfileViewModelProtocol {
    @Observable
    private(set) var userProfile: UserProfile?
    
    private let model: ProfileService
    private let imageValidator: ImageValidatorProtocol
    
    init(model: ProfileService, imageValidator: ImageValidatorProtocol = ImageValidator()) {
        self.model = model
        self.imageValidator = imageValidator
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(profileUpdated),
            name: NSNotification.Name("profileUpdated"),
            object: nil
        )
    }
    
    @objc
    private func profileUpdated() {
        fetchUserProfile()
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
    
    func userWillcloseViewController() {
        guard let userProfile = userProfile else { return }
        model.updateProfile(with: userProfile) { [weak self] result in
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
    
    func saveUserProfile() {
        guard let userProfile = userProfile else { return }
        model.updateProfile(with: userProfile) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let updatedProfile):
                DispatchQueue.main.async {
                    self.userProfile = updatedProfile
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchUserProfile() {
        ProgressHUD.show(NSLocalizedString("ProgressHUD.loading", comment: ""))
        
        model.fetchProfile { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let userProfile):
                    ProgressHUD.dismiss()
                    self.userProfile = userProfile
                case .failure(let error):
                    print(error)
                    ProgressHUD.showError("Ошибка загрузки профиля")
                    print(error)
                }
            }
        }
    }
}
