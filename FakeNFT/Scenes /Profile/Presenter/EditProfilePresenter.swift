//
//  File.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 23.04.2024.
//

import Foundation

protocol EditProfilePresenterProtocol {
    func viewDidLoad()
    func updateProfile(name: String?, description: String?, website: String?, newAvatarURL: String?)
}

protocol EditProfilePresenterDelegate: AnyObject {
    func profileDidUpdate(profile: Profile, newAvatarURL: String?)
}

final class EditProfilePresenter {
    // MARK: - Public Properties
    weak var view: EditProfileViewControllerProtocol?
    weak var delegate: EditProfilePresenterDelegate?
    
    // MARK: - Private Properties
    private var profile: Profile
    private let editProfileService: EditProfileService
    
    // MARK: - Initializers
    init(view: EditProfileViewControllerProtocol,
         profile: Profile,
         editProfileService: EditProfileService) {
        self.view = view
        self.profile = profile
        self.editProfileService = editProfileService
    }
}

extension EditProfilePresenter: EditProfilePresenterProtocol {
    func viewDidLoad() {
        view?.setProfile(profile: profile)
    }
    
    func updateProfile(name: String?, description: String?, website: String?, newAvatarURL: String?) {
        let updatedProfile = EditProfile(
            name: name ?? "",
            avatar: newAvatarURL ?? "",
            description: description ?? "",
            website: website ?? "",
            likes: nil
        )
        editProfileService.updateProfile(with: updatedProfile) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.delegate?.profileDidUpdate(profile: profile, newAvatarURL: newAvatarURL)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
    func handleError(_ error: Error) {
        print("UpdateProfile error")
    }
    
}
