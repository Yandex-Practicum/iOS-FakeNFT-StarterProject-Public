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
        let label = UICreator.makeLabel(text: "NO_INTERNET_ERROR".localized,
                                        font: UIFont.appFont(.bold, withSize: 17))
        label.isHidden = true
        return label
    }()
    private let retryButton = {
        let button = UICreator.makeButton(withTitle: "RETRY".localized,
                                          fontColor: UIColor.appWhite,
                                          backgroundColor: UIColor.appBlack,
                                          action: #selector(retryConnection))
        button.isHidden = true
        return button
    }()
    private let activityIndicator = UICreator.makeActivityIndicator()
    private let profileImageView = UICreator.makeImageView(cornerRadius: 35)
    private let profileNameLabel = UICreator.makeLabel()
    private let profileDescriptionLabel = UICreator.makeLabel(font: UIFont.appFont(.regular, withSize: 13))
    private let profileLinkTextView = UICreator.makeTextView(haveLinks: true, backgroundColor: .clear)
    private let profileMenuTableView = {
        let tableView = UICreator.makeTableView(isScrollable: false)
        tableView.register(ProfileMenuCell.self,
                           forCellReuseIdentifier: ProfileMenuCell.reuseIdentifier)
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
        checkForNetworkConnection()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Helpers
extension ProfileScreenController {

    @objc private func retryConnection() {
        activityIndicator.startAnimating()
        noInternetLabel.isHidden = true
        retryButton.isHidden = true
        checkForNetworkConnection()
    }

    private func setupAutolayout() {
        noInternetLabel.toAutolayout()
        retryButton.toAutolayout()
        activityIndicator.toAutolayout()
        profileImageView.toAutolayout()
        profileNameLabel.toAutolayout()
        profileDescriptionLabel.toAutolayout()
        profileLinkTextView.toAutolayout()
        profileMenuTableView.toAutolayout()
    }

    private func addSubviews() {
        view.addSubview(noInternetLabel)
        view.addSubview(retryButton)
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
            retryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant: LocalConstants.defaultSpacing),
            retryButton.topAnchor.constraint(equalTo: noInternetLabel.bottomAnchor,
                                             constant: LocalConstants.defaultSpacing),
            retryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -LocalConstants.defaultSpacing),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                      constant: LocalConstants.defaultSpacing),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                  constant: LocalConstants.defaultTopSpacing),
            profileImageView.widthAnchor.constraint(equalToConstant: LocalConstants.profileImageSize),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,
                                                      constant: LocalConstants.defaultSpacing),
            profileNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant: -LocalConstants.defaultSpacing),
            profileNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            profileDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                             constant: LocalConstants.defaultSpacing),
            profileDescriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,
                                                         constant: LocalConstants.defaultTopSpacing),
            profileDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                              constant: -LocalConstants.defaultTrailingSpacing),
            profileLinkTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: LocalConstants.defaultSpacing),
            profileLinkTextView.topAnchor.constraint(equalTo: profileDescriptionLabel.bottomAnchor,
                                                     constant: LocalConstants.profileLinkTopSpacing),
            profileLinkTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                          constant: -LocalConstants.defaultTrailingSpacing),
            profileLinkTextView.heightAnchor.constraint(equalToConstant: LocalConstants.profileLinkHeight),
            profileMenuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileMenuTableView.topAnchor.constraint(equalTo: profileLinkTextView.bottomAnchor,
                                                      constant: LocalConstants.profileMenuTopSpacing),
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

    private func checkForNetworkConnection() {
        if InternetConnectionManager.isConnectedToNetwork() {
            viewModel?.checkForData()
        } else {
            showNoInternetMessage()
        }
    }

    private func showNoInternetMessage() {
        activityIndicator.stopAnimating()
        noInternetLabel.isHidden = false
        retryButton.isHidden = false
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
        let profile = viewModel.profile
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
                ProfileNFTScreenController(viewModel: ProfileNFTScreenViewModel(profile: viewModel?.profile),
                                           delegate: self), animated: true)
        case 1:
            navigationController?.pushViewController(
                ProfileFavoritedNFTScreenController(
                    viewModel: ProfileFavoritedNFTScreenViewModel(profile: viewModel?.profile),
                    delegate: self), animated: true)
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
        guard let profile = viewModel?.profile else { return }
        present(ProfileEditingScreenController(viewModel: ProfileEditingScreenViewModel(profileToEdit: profile),
                                               delegate: self), animated: true)
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

// MARK: - ProfileScreenController LocalConstants
private enum LocalConstants {

    static let defaultSpacing: CGFloat = 16
    static let defaultTopSpacing: CGFloat = 20
    static let defaultTrailingSpacing: CGFloat = 18
    static let profileImageSize: CGFloat = 70
    static let profileLinkTopSpacing: CGFloat = 12
    static let profileLinkHeight: CGFloat = 20
    static let profileMenuTopSpacing: CGFloat = 44
}
