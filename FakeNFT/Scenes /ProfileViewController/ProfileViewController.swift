//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 23.03.2025.
//

import Foundation
import UIKit
import WebKit
import Kingfisher
import ProgressHUD

enum NFTScreenType {
    case nftScreen
    case favoritesScreen
}

final class ProfileViewController: UIViewController {
    
    private let servicesAssembly: ServicesAssembly
    private let profileView = ProfileView()
    private var profile: Profile?
    private var myNFTs: [String]?
    private let myNFTViewController = MyNFTViewController()
    private var blockingView: UIView?
    private var likes: [String]?
    private let likesStorage = LikesStorageImpl.shared
    
    
    // MARK: - UI Elements
    
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        let imageButton = UIImage(named: "Edit")
        button.setImage(imageButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        return button
    }()
    
    //
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    // MARK: - Initialization
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        likes = likesStorage.getAllLikes()
        view = profileView
        setupEditButton()
        loadProfile()
        
        profileView.myNFTTapped = { [weak self] in
                    guard let self = self else { return }
            if let nftIds = self.myNFTs, !nftIds.isEmpty {
                          self.loadNFTs(with: nftIds, for: .nftScreen)
                      } else {
                          self.showNFTScreen(with: [])
            }
        }
        
        profileView.favoritesTapped = { [weak self] in
                  guard let self = self else { return }
                  if let nftIds = self.likes, !nftIds.isEmpty {
                      self.loadNFTs(with: nftIds, for: .favoritesScreen)
                  } else {
                      self.showFavoritesScreen(with: [])
                  }
              }

        profileView.websiteLabelTapped = { [weak self] address in
            self?.didTapOnWebsiteLabel(with: address)
        }
        profileView.aboutDeveloper = { [weak self] address in
            self?.didTapOnWebsiteLabel(with: address)
        }
    }
    
    
    // MARK: - Setup Methods
    private func setupEditButton() {
        
        view.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    
    // MARK: - Private Methods
    
    private func loadProfile() {
        ProgressHUD.show()
        servicesAssembly.profileService.loadProfile { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                ProgressHUD.dismiss()
                switch result {
                case .success(let loadedProfile):
                    self.profile = loadedProfile
                    self.profileView.updateUI(with: loadedProfile)
                    self.myNFTs = loadedProfile.nfts
                    likesStorage.syncLikes(with: loadedProfile.likes)
                case .failure(let error):
                    self.showErrorAlert(with: error)
                }
            }
        }
    }
    
    private func showErrorAlert(with error: Error) {
        let alert = UIAlertController(
            title: NSLocalizedString("Error.title", comment: ""),
            message: NSLocalizedString("FailedToLoadProfile", comment: ""),
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(
            title: NSLocalizedString("TryAgain", comment: ""),
            style: .default
        ) { [weak self] _ in
            self?.loadProfile()
        }
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Cancel", comment: ""),
            style: .cancel,
            handler: nil
        )
        
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func loadNFTs(with ids: [String], for screenType: NFTScreenType) {
          var loadedNFTs: [MyNFT] = []
          let dispatchGroup = DispatchGroup()

          ProgressHUD.show()
          disableUserInteraction()

          for id in ids {
              dispatchGroup.enter()

              servicesAssembly.myNftService.loadNft(id: id) { [weak self] result in
                  switch result {
                  case .success(let nft):
                      loadedNFTs.append(nft)
                  case .failure(let error):
                      self?.showErrorAlert(with: error)
                  }
                  dispatchGroup.leave()
              }
          }

        dispatchGroup.notify(queue: .main) { [weak self] in
                   guard let self = self else { return }
              self.enableUserInteraction()
              ProgressHUD.dismiss()
            switch screenType {
                       case .nftScreen:
                           self.showNFTScreen(with: loadedNFTs)
                       case .favoritesScreen:
                           self.showFavoritesScreen(with: loadedNFTs)
                       }
          }
      }

      private func showNFTScreen(with nfts: [MyNFT]) {
          guard let navigationController = self.navigationController else { return }
          let myNFTViewController = MyNFTViewController()
          myNFTViewController.nfts = nfts
          myNFTViewController.hidesBottomBarWhenPushed = true
          myNFTViewController.saveLikes = { [weak self] in
                     guard let self = self else { return }

                     let likes = likesStorage.getAllLikes()

                     self.updateLikesOnServer(likes: likes) { result in
                         switch result {
                         case .success:
                             self.profileView.updateLikesCountAndUI()
                         case .failure(let error):
                             print("Ошибка при отправке лайков на сервер: \(error)")
                         }
                     }
                 }
          navigationController.pushViewController(myNFTViewController, animated: true)
      }
      
    private func showFavoritesScreen(with nfts: [MyNFT]) {
          guard let navigationController = self.navigationController else { return }
          let favoritesNftViewController = FavoritesNftViewController()

          favoritesNftViewController.favoriteNfts = nfts
          favoritesNftViewController.hidesBottomBarWhenPushed = true

          favoritesNftViewController.saveLikes = { [weak self] in
              guard let self = self else { return }

              self.likes = self.likesStorage.getAllLikes()
              self.updateLikesOnServer(likes: self.likes ?? []) { result in
                  switch result {
                  case .success:
                      self.profileView.updateLikesCountAndUI()
                  case .failure(let error):
                      print("Ошибка при отправке лайков на сервер: \(error)")
                  }
              }
          }

          navigationController.pushViewController(favoritesNftViewController, animated: true)
      }

      private func updateLikesOnServer(likes: [String], completion: @escaping (Result<Void, Error>) -> Void) {
          let likes = likesStorage.getAllLikes()
          servicesAssembly.profileService.updateLikes(likes: likes) { [weak self] result in
              switch result {
              case .success:
                  self?.likes = likes
                  completion(.success(()))
              case .failure(let error):
                  completion(.failure(error))
              }
          }
      }
    
    // MARK: - Actions
    
    @objc private func editProfileTapped() {
        guard let profile = profile else { return }
        editProfile(with: profile)
    }
    
    private func editProfile(with profile: Profile) {
        let editProfileVC = EditProfileViewController(profile: profile)
        editProfileVC.delegate = self
        
        editProfileVC.modalPresentationStyle = .formSheet
        present(editProfileVC, animated: true, completion: nil)
    }
    
    private func didTapOnWebsiteLabel(with urlString: String) {
        var validURLString = urlString
        
        
        if !urlString.hasPrefix("https://") {
            validURLString = "https://\(urlString)"
        }
        
        guard let url = URL(string: validURLString) else { return }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        let webViewController = UIViewController()
        webViewController.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: webViewController.view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: webViewController.view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: webViewController.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: webViewController.view.trailingAnchor)
        ])
        webViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    private func disableUserInteraction() {
           if blockingView == nil {
               let view = UIView(frame: UIScreen.main.bounds)
               view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
               view.isUserInteractionEnabled = true
               blockingView = view
           }

           if let blockingView = blockingView {
               UIApplication.shared.windows.first?.addSubview(blockingView)
           }
       }

       private func enableUserInteraction() {
           blockingView?.removeFromSuperview()
           blockingView = nil
       }
}

// MARK: - EditProfileDelegate
extension ProfileViewController: EditProfileDelegate {
    
    func didUpdateProfile(_ profile: Profile) {
        self.profile = profile
        profileView.updateUI(with: profile)
        
        let name = profile.name ?? ""
        let description = profile.description ?? ""
        let website = profile.website ?? ""
        let avatar = profile.avatar ?? ""
        
        
        servicesAssembly.profileService.updateProfile(
            name: name,
            description: description,
            website: website,
            avatar: avatar
        ) { result in
            switch result {
            case .success(let updatedProfile):
                print("Profile successfully updated: \(updatedProfile)")
            case .failure(let error):
                print("Error updating profile: \(error)")
            }
        }
    }
}

