//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Dinara on 23.03.2024.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileViewController {
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem
    }
}
