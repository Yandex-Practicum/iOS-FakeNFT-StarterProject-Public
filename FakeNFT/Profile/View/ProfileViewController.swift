//
//  ProfileViewController.swift
//  FakeNFT
//

import UIKit
import Kingfisher
import ProgressHUD

final class ProfileViewController: UIViewController {

    var viewModel: ProfileViewModelProtocol? = ProfileViewModel()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewBackgroundColor
        setupNavigationController()
        setupConstraints()
        UIBlockingProgressHUD.show()
        bind()
    }

    // MARK: - Private Funcs

    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.nameObservable.bind { [weak self] name in
            self?.nameLabel.text = name
        }
        viewModel.avatarURLObservable.bind { [weak self] url in
            self?.avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "AvatarPlaceholder")) { result in
                UIBlockingProgressHUD.dismiss()
                switch result {
                case .success(let value):
                    ImageCache.default.store(value.image, forKey: "avatar")
                case .failure(let error):
                    print("Error \(error): unable to load avatar image, will use placeholder image")
                    self?.avatarImageView.image = UIImage(named: "AvatarPlaceholder")
                }
            }
        }
        viewModel.descriptionObservable.bind { [weak self] description in
            self?.descriptionLabel.text = description
        }
        viewModel.websiteObservable.bind { [weak self] website in
            self?.websiteLabel.text = website
        }
        viewModel.nftsObservable.bind { [weak self] nfts in
            let cell = self?.profileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileTableViewCell
            cell?.setLabel(text: Constants.localizedStringFor(tableViewCell: 0, myNFT: nfts.count))
        }
        viewModel.likesObservable.bind { [weak self] likes in
            let cell = self?.profileTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ProfileTableViewCell
            cell?.setLabel(text: Constants.localizedStringFor(tableViewCell: 1, favoritesNFT: likes.count))
        }
    }

    private func setupNavigationController() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let buttonImage = UIImage(systemName: "square.and.pencil", withConfiguration: imageConfig)
        let rightButton = UIBarButtonItem(image: buttonImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(editProfileButtonAction))
        rightButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightButton
    }

    @objc private func editProfileButtonAction() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.viewModel = viewModel
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
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileTableViewCell = tableView.dequeueReusableCell()
        cell.setLabel(text: Constants.localizedStringFor(tableViewCell: indexPath.row))
        return cell
    }
}
