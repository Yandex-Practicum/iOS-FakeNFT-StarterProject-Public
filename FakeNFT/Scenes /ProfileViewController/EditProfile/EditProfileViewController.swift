//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 24.03.2025.
//


import UIKit
import Kingfisher

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfile(_ profile: Profile)
}

final class EditProfileViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: EditProfileDelegate?
    private lazy var editProfileView = EditProfileView()
    private var profile: Profile
    private var updatedAvatarURL: String?
    
    // MARK: - Initializers
    
    init(profile: Profile) {
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = editProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editProfileView.closeTapped = { [weak self] in
            self?.closeButtonTapped()
        }
        editProfileView.avatarTapped = { [weak self] in
            self?.presentImageURLInputDialog()
        }
        
        populateProfileData()
    }
    
    // MARK: - Data Population
    
    private func populateProfileData() {
        editProfileView.nameTextView.text = profile.name
        editProfileView.infoTextView.text = profile.description
        editProfileView.siteTextView.text = profile.website
        
        if let avatarURLString = profile.avatar, let url = URL(string: avatarURLString) {
            editProfileView.profileAvatar.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
        } else {
            editProfileView.profileAvatar.image = UIImage(systemName: "person.crop.circle")
        }
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonTapped() {
        profile.name = editProfileView.nameTextView.text
        profile.description = editProfileView.infoTextView.text
        profile.website = editProfileView.siteTextView.text
        profile.avatar = updatedAvatarURL ?? profile.avatar
        
        delegate?.didUpdateProfile(profile)
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Avatar Handling
    
    private func chooseNewAvatar(url: URL) {
        updatedAvatarURL = url.absoluteString
        
        editProfileView.profileAvatar.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
    }
    
}



extension EditProfileViewController {
    private func presentImageURLInputDialog() {
          let alertController = UIAlertController(title: NSLocalizedString("EnterImageURL", comment: ""),
                                                  message: NSLocalizedString("PleaseEnterURLForAvatar", comment: ""),
                                                  preferredStyle: .alert)
  
          alertController.addTextField { textField in
              textField.placeholder = NSLocalizedString("AvatarURL", comment: "")
              textField.keyboardType = .URL
          }
  
          let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { [weak self] _ in
              if let urlString = alertController.textFields?.first?.text, let url = URL(string: urlString) {
                  self?.chooseNewAvatar(url: url)
              }
          }
  
          alertController.addAction(confirmAction)
  
          alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
  
          present(alertController, animated: true, completion: nil)
      }
}
