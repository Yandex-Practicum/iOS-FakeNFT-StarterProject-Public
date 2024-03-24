//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Dinara on 23.03.2024.
//

import Kingfisher
import SnapKit
import UIKit

// MARK: - ProfileViewControllerProtocol
public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(_ profile: Profile?)
    func updateAvatar(url: URL)
}

// MARK: - ProfileViewController Class 
final class ProfileViewController: UIViewController {

    // MARK: - Public Properties
    let servicesAssembly: ServicesAssembly
    var presenter: ProfilePresenterProtocol?

    // MARK: - Private Properties
    private var profile: Profile?
    private let tableViewLabels: [String] = [
        L10n.Profile.myNFT,
        L10n.Profile.favoritesNFT,
        L10n.Profile.aboutDeveloper
    ]
    private lazy var value: [String?] = [
        "\(profile?.nfts.count ?? 0)",
        "\(profile?.likes.count ?? 0)",
        nil
    ]

    // MARK: - UI
    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(editBarButtonTapped)
        )
        button.tintColor = UIColor(named: "ypUniBlack")
        return button
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypUniBlack")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()

    // swiftlint:disable all
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypUniBlack")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    // swiftlint:enable all

    private lazy var siteLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypUniBlue")
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            ProfileCell.self,
            forCellReuseIdentifier: ProfileCell.cellID
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.isScrollEnabled = false
        return tableView
    }()

    // MARK: - Init
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
}

// MARK: - ProfileViewController Class
private extension ProfileViewController {
    // MARK: - Setup Navigation
    func setupNavigation() {
        navigationItem.rightBarButtonItem = editButton
    }

    // MARK: - Setup Views
    func setupViews() {
        view.backgroundColor = .systemBackground

        [avatarImageView,
         nameLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        [stackView,
         descriptionLabel,
         siteLabel
        ].forEach {
            userInfoStackView.addArrangedSubview($0)
        }

        userInfoStackView.setCustomSpacing(8, after: descriptionLabel)

        [userInfoStackView,
         tableView
        ].forEach {
            view.addSubview($0)
        }
    }

    // MARK: - Setup Constraints
    func setupConstraints() {
        let cellHeight = CGFloat(54)

        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(70)
        }

        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }

        userInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(userInfoStackView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(cellHeight * 3)
        }
    }

    // MARK: - Actions
    @objc func editBarButtonTapped() {
        print("editBarButton Did Tap")
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewLabels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileCell.cellID,
            for: indexPath
        ) as? ProfileCell else {
            fatalError("Could not cast to ProfileCell")
        }

        let label = tableViewLabels[indexPath.row]

        cell.configureCell(
            label: label,
            value: value[indexPath.row]
        )
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("My NFTs cell did tap")
        case 1:
            print("My Favourite NFTs cell did tap")
        case 2:
            print("About Developer cell did tap")
            let viewController = AboutDeveloperViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}

// MARK: - ProfileViewControllerProtocol
extension ProfileViewController: ProfileViewControllerProtocol {
    func updateProfileDetails(_ profile: Profile?) {
        if let profile {
            nameLabel.text = profile.name
            descriptionLabel.text = profile.description
            siteLabel.text = profile.website
            guard let avatarURLString = ProfileService.shared.profile?.avatar,
                  let avatarURL = URL(string: avatarURLString) else {
                return
            }
            updateAvatar(url: avatarURL)
            let myNFTs = tableView.cellForRow(at: [0, 0]) as? ProfileCell
            myNFTs?.configureCell(label: nil, value: "(\(String(profile.nfts.count)))")

            let myFavorites = tableView.cellForRow(at: [0, 1]) as? ProfileCell
            myFavorites?.configureCell(label: nil, value: "(\(String(profile.likes.count)))")
        } else {
            nameLabel.text = ""
            descriptionLabel.text = ""
            siteLabel.text = ""
            avatarImageView.image = UIImage()
        }
    }

    func updateAvatar(url: URL) {
        avatarImageView.kf.setImage(with: url)
    }
}
