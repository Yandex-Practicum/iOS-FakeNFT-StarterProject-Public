//
//  ProfileScreenViewModel.swift
//  FakeNFT
//
//  Created by Илья Валито on 19.06.2023.
//

import UIKit

// MARK: ProfileScreenViewModel
final class ProfileScreenViewModel {

    // MARK: - Properties and Initializers
    @Observable
    private(set) var canShowUI: Bool = false

    private let networkClient = DefaultNetworkClient()

    var profile: ProfileModel?
    private let menuButtons = [
        "MY_NFT".localized,
        "FAVORITED_NFT".localized,
        "ABOUT_DEVELOPER".localized
    ]
}

// MARK: Helpers
extension ProfileScreenViewModel {

    func checkForData() {
        networkClient.send(request: ProfileRequest(httpMethod: .get), type: ProfileModel.self) { profile in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.profile = try? profile.get()
                self.canShowUI = true
            }
        }
    }

    func giveNumberOfMenuCells() -> Int {
        return menuButtons.count
    }

    func configureCell(forTableView tableView: UITableView, atRow row: Int) -> UITableViewCell {
        let cell = ProfileMenuCell()
        if row == 0 {
            cell.menuCategoryLabel.text = "\(menuButtons[row]) (\(profile?.nfts.count ?? 0))"
        } else if row == 1 {
            cell.menuCategoryLabel.text = "\(menuButtons[row]) (\(profile?.likes.count ?? 0))"
        } else {
            cell.menuCategoryLabel.text = menuButtons[row]
        }
        let chevronImage = UIImageView(image: UIImage(systemName: Constants.IconNames.chevronRight))
        chevronImage.tintColor = .appBlack
        cell.accessoryView = chevronImage
        cell.backgroundColor = .clear
        return cell
    }

    func configureWebView() -> WebController {
        let webController = WebController()
        if let webURL = URL(string: profile?.website ?? Constants.Links.defaultLink) {
            let request = URLRequest(url: webURL)
            webController.webView.webView.load(request)
        }
        return webController
    }
}
