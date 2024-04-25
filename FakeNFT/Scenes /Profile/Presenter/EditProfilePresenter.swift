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
    func profileDidUpdate(_ profile: Profile, newAvatarURL: String?)
}

final class EditProfilePresenter {
    // MARK: - Public Properties
    weak var view: EditProfileViewControllerProtocol?
    weak var delegate: EditProfilePresenterDelegate?
    
    // MARK: - Private Properties
    private var profile: Profile
    
    // MARK: - Initializers
    init(view: EditProfileViewControllerProtocol,
         profile: Profile) {
        self.view = view
        self.profile = profile
    }
}

extension EditProfilePresenter: EditProfilePresenterProtocol {
    func viewDidLoad() {
        view?.setProfile(profile: profile)
    }
    
    func updateProfile(name: String?, description: String?, website: String?, newAvatarURL: String?) {
        let updateProfile = EditProfile(
            name: name ?? "",
            avatar: description ?? "",
            description: newAvatarURL ?? "",
            website: website ?? "",
            likes: nil
        )
        
    }
    
    
}
