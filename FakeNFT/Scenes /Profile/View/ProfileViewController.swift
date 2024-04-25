//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 03.04.2024.
//

import Foundation
import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenter? {get set}
    func updateProfile(profile: Profile?)
    func updateAvatar(url: URL)
}

final class ProfileViewController: UIViewController {
    
    //MARK:  - Public Properties
    let servicesAssembly: ServicesAssembly
    var presenter: ProfilePresenter?
    weak var delegate: ProfilePresenterDelegate?
    
    //MARK:  - Private Properties
    private let tableСell = ["Мой NFT", "Избранные NFT", "О разработчике"]
    private var myNFTCount = 0
    private var favoritesNFTCount = 0
    
    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem( image: UIImage(systemName: "square.and.pencil"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(editButtonTap))
        button.tintColor = UIColor(named: "ypBlack")
        return button
    }()
    
    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "avatar")
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProBold22
        label.text = "Joaquin Phoenix"
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProRegular13
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.text = "Дизайнер из Казани, люблю цифровое искусство\n и бейглы. В моей коллекции уже 100+ NFT,\n и еще больше — на моём сайте. Открыт\n к коллаборациям."
        label.textColor = UIColor(named: "ypBlack")
        return label
    }()
    
    private lazy var siteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProRegular15
        label.text = "Joaquin Phoenix.com"
        label.textColor = UIColor(named: "ypBlueUn")
        let action = UITapGestureRecognizer(
            target: self,
            action: #selector(goToWebsiteTap(_:))
        )
        label.addGestureRecognizer(action)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var smollStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.backgroundColor = UIColor(named: "ypWhite")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bigStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        stackView.backgroundColor = UIColor(named: "ypWhite")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            ProfileCell.self,
            forCellReuseIdentifier: ProfileCell.cellID
        )
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Initialization
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Action
    @objc func editButtonTap() {
        presenter?.didTapEditProfile()
    }
    
    @objc func goToWebsiteTap(_ sender: UITapGestureRecognizer) {
        //        var urlString = "https://\(siteLabel.text)"
        //        if let url = URL(string: urlString) {
        //            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        //        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizingNavigation()
        customizingScreenElements()
        customizingTheLayoutOfScreenElements()
        delegate = self
        presenter?.delegate = self
    }
    //MARK: - Private Methods
    func customizingNavigation() {
        navigationItem.rightBarButtonItem = editButton
    }
    
    private func customizingScreenElements() {
        view.backgroundColor = .systemBackground
        
        [profileImage, nameLabel].forEach {smollStackView.addArrangedSubview($0)}
        [smollStackView, descriptionLabel, siteLabel].forEach {bigStackView.addArrangedSubview($0)}
        [bigStackView, profileTableView].forEach {view.addSubview($0)}
    }
    
    private func customizingTheLayoutOfScreenElements() {
        bigStackView.setCustomSpacing(8, after: descriptionLabel)
        
        NSLayoutConstraint.activate([
            bigStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            bigStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            bigStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            bigStackView.heightAnchor.constraint(equalToConstant: 198),
            
            smollStackView.topAnchor.constraint(equalTo: bigStackView.topAnchor),
            smollStackView.leadingAnchor.constraint(equalTo: bigStackView.leadingAnchor),
            smollStackView.trailingAnchor.constraint(equalTo: bigStackView.trailingAnchor),
            smollStackView.heightAnchor.constraint(equalToConstant: 70),
            
            profileTableView.topAnchor.constraint(equalTo: bigStackView.bottomAnchor, constant: 40),
            profileTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            profileTableView.heightAnchor.constraint(equalToConstant: 162),
        ])
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableСell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.cellID,for: indexPath) as? ProfileCell else {fatalError("Could not cast to CategoryCell")}
        let name = tableСell[indexPath.row]
        switch indexPath.row {
        case 0:
            let number = "\(myNFTCount)"
            cell.changingLabels(nameView: name, numberView: number)
            return cell
        case 1:
            let number = "\(favoritesNFTCount)"
            cell.changingLabels(nameView: name, numberView: number)
            return cell
        case 2:
            
            cell.changingLabels(nameView: name, numberView: "")
            return cell
        default:
            break
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            presenter?.didTapMyNFT()
        case 1:
            presenter?.didTapFavoriteNFT()
        case 2:
            print("Кнопка О разработчике функционирует")
        default:
            break
        }
    }
}

// MARK: - ProfileViewControllerProtocol
extension ProfileViewController: ProfileViewControllerProtocol {
    func updateProfile(profile: Profile?) {
        if let profile {
            nameLabel.text = profile.name
            descriptionLabel.text = profile.description
            siteLabel.text = profile.website
            
            guard let avatarURLString = profile.avatar,
                  let avatarURL = URL(string: avatarURLString) else {
                return
            }
            updateAvatar(url: avatarURL)
            myNFTCount = profile.nfts.count
            favoritesNFTCount = profile.likes.count
            profileTableView.reloadData()
        } else {
            nameLabel.text = ""
            descriptionLabel.text = ""
            siteLabel.text = ""
            profileImage.image = UIImage()
        }
    }
    
    func updateAvatar(url: URL) {
        profileImage.kf.setImage(with: url, options: [.forceRefresh])
    }
}

// MARK: - EditProfilePresenterDelegate
extension ProfileViewController: EditProfilePresenterDelegate {
    func profileDidUpdate(_ profile: Profile, newAvatarURL: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.updateProfile(profile: profile)
            self?.presenter?.updateUserProfile(with: profile)
        }
    }
}

// MARK: - ProfilePresenterDelegate
extension ProfileViewController: ProfilePresenterDelegate {
    func goToMyNFT(with nftID: [String], and likedNFT: [String]) {
        
        let myNFTViewController = MyNFTViewController(nftID: nftID, likedID: likedNFT)
        myNFTViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myNFTViewController, animated: true)
    }
    
    func goToFavoriteNFT(with nftID: [String], and likedNFT: [String]) {
        
        let favoritesNFTViewController = FavoritesNFTViewController(nftID: nftID, likedID: likedNFT)
        favoritesNFTViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(favoritesNFTViewController, animated: true)
    }
    
    func goToEditProfile(profile: Profile) {
        let editProfileViewController = EditProfileViewController(presenter: nil, cell: nil)
        editProfileViewController.editProfilePresenterDelegate = self
        let editProfilePresenter = EditProfilePresenter(
            view: editProfileViewController,
            profile: profile
        )
        editProfilePresenter.delegate = self
        editProfileViewController.presenter = editProfilePresenter
        editProfileViewController.modalPresentationStyle = .pageSheet
        present(editProfileViewController, animated: true)
    }
}
