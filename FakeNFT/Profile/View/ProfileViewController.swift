//
//  ProfileViewController.swift
//  FakeNFT
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {

    var viewModel: ProfileViewModelProtocol? = ProfileViewModel()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        imageView.image = UIImage(named: "AvatarPlaceholder")
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .textColorBlack
        label.text = "Joaquin Phoenix"
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .textColorBlack
        label.numberOfLines = 0
        label.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        return label
    }()

    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .textColorBlue
        label.text = "Joaquin Phoenix.com"
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
        bind()
    }

    // MARK: - Private Funcs

    private func bind() {
        guard let viewModel = viewModel else { return }

        //imageView.kf.setImage(with: viewModel?.avatarURL, placeholder: UIImage(named: "AvatarPlaceholder"))
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

    }

    private func setupConstraints() {
        [avatarImageView, nameLabel, descriptionLabel, websiteLabel, profileTableView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

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
        cell.setLabel(text: "Hello, world!")
        return cell
    }
}
