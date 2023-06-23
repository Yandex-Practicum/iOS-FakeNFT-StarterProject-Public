//
//  ProfileScreenController.swift
//  FakeNFT
//
//  Created by Илья Валито on 19.06.2023.
//

import UIKit

// MARK: - ProfileScreenController
final class ProfileScreenController: UIViewController {

    // MARK: - Properties and Initializers
    private var viewModel: ProfileScreenViewModel?

    private let noInternetLabel = {
       let label = UICreator.shared.makeLabel(text: "Нет интернета", font: UIFont.appFont(.bold, withSize: 17))
        label.isHidden = true
        return label
    }()
    private let activityIndicator = UICreator.shared.makeActivityIndicator()
    private let profileImageView = UICreator.shared.makeImageView(cornerRadius: 35)
    private let profileNameLabel = UICreator.shared.makeLabel()
    private let profileDescriptionLabel = UICreator.shared.makeLabel(font: UIFont.appFont(.regular, withSize: 13))
    private let profileLinkTextView = UICreator.shared.makeTextView(haveLinks: true, backgroundColor: .clear)
    private let profileMenuTableView = {
        let tableView = UICreator.shared.makeTableView(isScrollable: false)
        tableView.register(ProfileMenuCell.self,
                           forCellReuseIdentifier: Constants.CollectionElementNames.profileMenuCell)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appWhite
        setupAutolayout()
        addSubviews()
        setupConstraints()
        (navigationController as? NavigationController)?.profileEditingButtonDelegate = self
        navigationItem.backButtonTitle = ""
        profileMenuTableView.dataSource = self
        profileMenuTableView.delegate = self
        profileLinkTextView.delegate = self
        showOrHideUI()
        viewModel = ProfileScreenViewModel()
        bind()
        if InternetConnectionManager.isConnectedToNetwork() {
            viewModel?.checkForData()
        } else {
            showNoInternetMessage()
        }
    }
}

// MARK: - Helpers
extension ProfileScreenController {

    private func setupAutolayout() {
        noInternetLabel.toAutolayout()
        activityIndicator.toAutolayout()
        profileImageView.toAutolayout()
        profileNameLabel.toAutolayout()
        profileDescriptionLabel.toAutolayout()
        profileLinkTextView.toAutolayout()
        profileMenuTableView.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(noInternetLabel)
        view.addSubview(activityIndicator)
        view.addSubview(profileImageView)
        view.addSubview(profileNameLabel)
        view.addSubview(profileDescriptionLabel)
        view.addSubview(profileLinkTextView)
        view.addSubview(profileMenuTableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            noInternetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noInternetLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            profileNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            profileDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileDescriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            profileDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            profileLinkTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileLinkTextView.topAnchor.constraint(equalTo: profileDescriptionLabel.bottomAnchor, constant: 12),
            profileLinkTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            profileLinkTextView.heightAnchor.constraint(equalToConstant: 20),
            profileMenuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileMenuTableView.topAnchor.constraint(equalTo: profileLinkTextView.bottomAnchor, constant: 44),
            profileMenuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileMenuTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.$canShowUI.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                self.fillUI()
                self.showOrHideUI()
            }
        }
    }

    private func showNoInternetMessage() {
        activityIndicator.stopAnimating()
        noInternetLabel.isHidden = false
    }

    private func showOrHideUI() {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
        profileImageView.isHidden.toggle()
        profileNameLabel.isHidden.toggle()
        profileDescriptionLabel.isHidden.toggle()
        profileLinkTextView.isHidden.toggle()
        profileMenuTableView.isHidden.toggle()
    }

    private func fillUI() {
        guard let viewModel else { return }
        let profile = viewModel.giveData()
        profileImageView.loadImage(urlString: profile?.avatar)
        profileNameLabel.text = profile?.name
        profileDescriptionLabel.text = profile?.description
        profileLinkTextView.text = profile?.website
        profileMenuTableView.reloadData()
    }
}

// MARK: - UITableViewDataSourceDelegate
extension ProfileScreenController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.giveNumberOfMenuCells() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel?.configureCell(forTableView: tableView, atRow: indexPath.row) ?? UITableViewCell()
    }
}

// MARK: - UITableViewDataSourceDelegate
extension ProfileScreenController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(
                ProfileNFTScreenController(profile: viewModel?.giveData(), delegate: self), animated: true)
        case 1:
            navigationController?.pushViewController(
                ProfileFavoritedNFTScreenController(profile: viewModel?.giveData(), delegate: self), animated: true)
        case 2:
            guard let viewModel else { return }
            navigationController?.pushViewController(viewModel.configureWebView(), animated: true)
        default:
            return
        }
    }
}

// MARK: - ProfileEditingButtonDelegate
extension ProfileScreenController: ProfileEditingButtonDelegate {
    func proceedToEditing() {
        guard let profile = viewModel?.giveData() else { return }
        present(ProfileEditingScreenController(forProfile: profile, delegate: self), animated: true)
    }
}

// MARK: - ProfileEditingScreenDelegate
extension ProfileScreenController: ProfileUIUpdateDelegate {
    func updateUI() {
        DispatchQueue.global().sync { [weak self] in
            guard let self else { return }
            self.viewModel?.checkForData()
            self.fillUI()
            self.showOrHideUI()
        }
    }
}

// MARK: - UITextViewDelegate
extension ProfileScreenController: UITextViewDelegate {

    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction
    ) -> Bool {
        guard let viewModel else { return true }
        navigationController?.pushViewController(viewModel.configureWebView(), animated: true)
        return false
    }
}
