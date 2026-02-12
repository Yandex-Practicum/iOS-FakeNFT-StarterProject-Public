//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 21.01.2026.
//

import UIKit
import Kingfisher

// MARK: - Protocols

protocol ProfileViewProtocol: AnyObject {
    func openEditProfile(model: ProfileEditModel)
    func getProfileEditModel() -> ProfileEditModel
    func openMyNFTs()
    func openFavoritesNFTs()
    func openWebView(url: URL)
}

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {

    // MARK: - Properties

    private let presenter: ProfilePresenterProtocol
    let servicesAssembly: ServicesAssembly

    let name = "Joaquin Phoenix"
    let descriptionText = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
    let sait = "https://www.drive2.ru/experience/bmw/m287#results"

    private var profileCellName: [ProfileItem] = [
        ProfileItem(type: .myNFT, count: 0),
        ProfileItem(type: .myFavorites, count: 0)
    ]

    // MARK: - UI

    private lazy var editButton: UIBarButtonItem = {
        let image = UIImage(resource: .squareAndPencil)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(tapEditButton))
        button.tintColor = .blackApp
        return button
    }()

    private lazy var avatarImage: UIImageView = {
        let image = UIImageView.baseAvatarImage()
        image.image = UIImage(resource: .joaquinPhoenix)
        return image
    }()

    private lazy var avatarName: UILabel = {
        let label = UILabel()
        label.text = name
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .blackApp
        return label
    }()

    private lazy var personStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImage, avatarName])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.textColor = .blackApp
        label.text = descriptionText
        return label
    }()

    private lazy var webSiteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .blueUniversal
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapWebSiteLabel))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        label.text = sait
        return label
    }()

    private lazy var bigStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [personStack, descriptionLabel, webSiteLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.setCustomSpacing(20, after: personStack)
        stack.setCustomSpacing(8, after: descriptionLabel)
        return stack
    }()

    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .whiteApp
        tableView.isScrollEnabled = false
        return tableView
    }()

    // MARK: - Initializers

    init(servicesAssembly: ServicesAssembly, presenter: ProfilePresenterProtocol) {
        self.servicesAssembly = servicesAssembly
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteApp
        setupNavigationBar()
        addSubviews()
        setupConstraints()
        navigationItem.title = nil
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = editButton
    }

    private func addSubviews() {
        [bigStack, profileTableView].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        [bigStack, profileTableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            bigStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            bigStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bigStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            personStack.topAnchor.constraint(equalTo: bigStack.topAnchor),
            personStack.leadingAnchor.constraint(equalTo: bigStack.leadingAnchor),
            personStack.trailingAnchor.constraint(equalTo: bigStack.trailingAnchor),
            personStack.heightAnchor.constraint(equalToConstant: 70),

            profileTableView.topAnchor.constraint(equalTo: bigStack.bottomAnchor, constant: 40),
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func tapEditButton() {
        presenter.didTapEdit()
        print("переход к экрану редактирования профиля")
    }

    @objc private func tapWebSiteLabel() {
        guard let url = webSiteLabel.text else { return }
        presenter.didTapWebSite(url: url)
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileCellName.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileCell.reuseIdentifier,
            for: indexPath
        ) as? ProfileCell else {
            return UITableViewCell()
        }

        let item = profileCellName[indexPath.row]
        cell.configure(title: item.type.title, count: "(\(item.count))")
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = profileCellName[indexPath.row]

        switch item.type {
        case .myNFT:
            presenter.openMyNFTs()
            print("Переход к экрану Мои NFT")
        case .myFavorites:
            presenter.openFavoritesNFC()
            print("Переход к экрану Избранные NFT")
        }
    }
}

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {

    func openEditProfile(model: ProfileEditModel) {
        let presenter = ProfileEditPresenter(model: model)
        let editVC = ProfileEditViewController(presenter: presenter)
        presenter.view = editVC
        navigationController?.pushViewController(editVC, animated: true)
    }

    func getProfileEditModel() -> ProfileEditModel {
        ProfileEditModel(name: name, description: descriptionText, site: sait)
    }

    func openMyNFTs() {
        let presenter = MyNFTsPresenter()
        let myNFTsVC = MyNFTsViewController(presenter: presenter)
        presenter.view = myNFTsVC
        navigationController?.pushViewController(myNFTsVC, animated: true)
    }

    func openFavoritesNFTs() {
        let presenter = FavoritesNFTPresenter()
        let myNFTsVC = FavoritesNFTViewController(presenter: presenter)
        presenter.view = myNFTsVC
        navigationController?.pushViewController(myNFTsVC, animated: true)
    }
    
    func openWebView(url: URL) {
        let presenter = WebViewPresenter()
        let webVC = WebViewProfile(url: url, presenter: presenter)
        presenter.view = webVC
        navigationController?.pushViewController(webVC, animated: true)
    }

}
