//
//  ProfileViewController.swift
//  FakeNFT
//

import UIKit
import Kingfisher
import ProgressHUD

final class ProfileViewController: UIViewController {

    private let profileViewModel: ProfileViewModelProtocol

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.kf.indicatorType = .activity
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .textColorBlack
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .textColorBlack
        label.numberOfLines = 0
        return label
    }()

    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .textColorBlue
        return label
    }()

    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(ProfileTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    // MARK: - LifeCycle

    required init?(coder: NSCoder) {
        self.profileViewModel = ProfileViewModel()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewBackgroundColor
        setupNavigationController()
        setupConstraints()
        bind()
        profileViewModel.profileViewDidLoad()
    }

    // MARK: - Private Funcs

    private func bind() {
        profileViewModel.nameObservable.bind { [weak self] name in
            self?.nameLabel.text = name
        }
        profileViewModel.avatarURLObservable.bind { [weak self] url in
            self?.avatarImageView.kf.setImage(with: url,
                                              placeholder: UIImage(named: Constants.avatarPlaceholder)) { result in
                switch result {
                case .success(let value):
                    ImageCache.default.store(value.image, forKey: "avatar")
                case .failure(let error):
                    print("Error \(error): unable to load avatar image, will use placeholder image")
                    self?.avatarImageView.image = UIImage(named: Constants.avatarPlaceholder)
                }
            }
        }
        profileViewModel.descriptionObservable.bind { [weak self] description in
            self?.descriptionLabel.text = description
        }
        profileViewModel.websiteObservable.bind { [weak self] website in
            self?.websiteLabel.text = website
        }
        profileViewModel.nftsObservable.bind { [weak self] _ in
            self?.profileTableView.performBatchUpdates {
                self?.profileTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
        profileViewModel.likesObservable.bind { [weak self] _ in
            self?.profileTableView.performBatchUpdates {
                self?.profileTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
        }
        profileViewModel.isProfileUpdatingNowObservable.bind { isProfileUpdatingNow in
            isProfileUpdatingNow ? UIBlockingProgressHUD.show() : UIBlockingProgressHUD.dismiss()
        }
        profileViewModel.profileReceivingErrorObservable.bind { [weak self] error in
            self?.showAlertMessage(with: error) { self?.profileViewModel.profileViewDidLoad() }
        }
    }

    private func setupNavigationController() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let buttonImage = UIImage(systemName: "square.and.pencil", withConfiguration: imageConfig)
        let rightButton = UIBarButtonItem(image: buttonImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(editProfileButtonAction))
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .textColorBlack
    }

    @objc private func editProfileButtonAction() {
        let editProfileViewController = EditProfileViewController(profileViewModel: profileViewModel)
        present(editProfileViewController, animated: true)
    }

    private func setupConstraints() {
        [avatarImageView, nameLabel, descriptionLabel, websiteLabel, profileTableView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 13),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            websiteLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            websiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            profileTableView.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 44),
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func show(_ profileOption: ProfileOption) {
        let viewModel = profileViewModel.didSelect(profileOption)
        var viewController: UIViewController
        switch profileOption {
        case .myNFT:
            guard let nftsViewModel = viewModel as? NFTsViewModelProtocol else { return }
            viewController = MyNFTViewController(nftsViewModel: nftsViewModel)
        case .favoritesNFT:
            guard let nftsViewModel = viewModel as? NFTsViewModelProtocol else { return }
            viewController = FavoritesNFTViewController(nftsViewModel: nftsViewModel)
        case .website:
            guard let websiteViewModel = viewModel as? WebsiteViewModelProtocol else { return }
            viewController = WebsiteViewController(websiteViewModel: websiteViewModel)
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let profileOption = ProfileOption(rawValue: indexPath.row) else { return }
        show(profileOption)
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileOption = ProfileOption(rawValue: indexPath.row) else { return UITableViewCell() }
        let cell: ProfileTableViewCell = tableView.dequeueReusableCell()
        cell.setLabel(text: profileViewModel.labelTextFor(profileOption))
        return cell
    }
}
