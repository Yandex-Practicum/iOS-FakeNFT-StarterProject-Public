//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 12.07.2024.
//  
//

import UIKit

protocol ProfileViewProtocol: AnyObject {

}

final class ProfileViewController: UIViewController {

    var presenter: ProfilePresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {

}
