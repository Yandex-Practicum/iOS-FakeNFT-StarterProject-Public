//
//  NavigationController.swift
//  FakeNFT
//
//  Created by Илья Валито on 18.06.2023.
//

import UIKit

// MARK: - ProfileEditingButtonDelegate protocol
protocol ProfileEditingButtonDelegate: AnyObject {
    func proceedToEditing()
}

// MARK: - NavigationControllerSortingButtonDelegate protocol {
protocol NavigationControllerSortingButtonDelgate: AnyObject {
    func sortTapped()
}

// MARK: - NavigationController
final class NavigationController: UINavigationController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }

    var profileEditingButtonDelegate: ProfileEditingButtonDelegate?
    var sortingButtonDelegate: NavigationControllerSortingButtonDelgate?

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configureNavigationController(forVC: rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Helpers
extension NavigationController {

    @objc private func editTapped() {
        profileEditingButtonDelegate?.proceedToEditing()
    }

    @objc private func sortTapped() {
        sortingButtonDelegate?.sortTapped()
    }

    private func configureNavigationController(forVC viewController: UIViewController) {
        navigationBar.tintColor = .appBlack
        navigationBar.titleTextAttributes = [
            .font: UIFont.appFont(.bold, withSize: 17),
            .foregroundColor: UIColor.appBlack
        ]

        // configure a navigation controller for a currently selected TabBar tab (your epic's main VC)
        if viewController is ProfileScreenController {
            navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.IconNames.edit),
                                                                        style: .done,
                                                                        target: nil,
                                                                        action: #selector(editTapped))
        } else {
            navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.IconNames.sort),
                                                                        style: .done,
                                                                        target: nil,
                                                                        action: #selector(sortTapped))
        }
    }
}
