//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Dinara on 23.03.2024.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    // MARK: - Properties
    let servicesAssembly: ServicesAssembly

    // MARK: - Init
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private lazy var editBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(editBarButtonTapped))
        button.tintColor = UIColor(named: "ypUniBlack")
        return button
    }()

    private lazy var profileView: ProfileView = {
        let view = ProfileView()
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupConstraints()
    }
}

private extension ProfileViewController {
    // MARK: - Setup Navigation
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = editBarButton
    }

    // MARK: - SetupViews
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(profileView)
    }

    // MARK: - SetupConstraints
    func setupConstraints() {
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Actions
    @objc func editBarButtonTapped() {
        print("editBarButton Did Tap")
    }
}
