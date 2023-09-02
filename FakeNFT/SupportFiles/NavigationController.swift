//
//  NavigationController.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 28.07.2023.
//

import UIKit

protocol EditProfileButtonDelegate: AnyObject {
    func proceedToEditing()
}

final class NavigationController: UINavigationController {
    var editProfileButtonDelegate: EditProfileButtonDelegate?
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configureNavigationController(forVC: rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("NavigationController: init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc private func editTapped() {
        editProfileButtonDelegate?.proceedToEditing()
    }

    @objc private func sortTapped() {
    }

    private func configureNavigationController(forVC viewController: UIViewController) {
        navigationBar.tintColor = .appBlack
        navigationBar.titleTextAttributes = [
            .font: UIFont.getFont(style: .bold, size: 17),
            .foregroundColor: UIColor.appBlack
        ]
        
        if viewController is ProfileViewController {
            navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
                image: UIImage.Icons.edit,
                style: .done,
                target: nil,
                action: #selector(editTapped)
            )
        }
    }
}
