//
//  ProfileTableViewCell.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 23.03.2025.
//

import UIKit

final class ProfileView: UIView {
    
    private let likesStorage = LikesStorageImpl.shared
    private var nftsCount: Int = 3
    private var likesCount: Int = 0
    var websiteLabelTapped: ((String) -> Void)?
    var favoritesTapped: (() -> Void)?
    var aboutDeveloper: ((String) -> Void)?
    var myNFTTapped: (() -> Void)?
  
    
   
    
    // MARK: - UI Elements
    
    private lazy var profileAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mock Name"
        label.textColor = UIColor(named: "YBlackColor")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var userWebSiteLabel: UILabel = {
        let label = UILabel()
        label.text = "practicum.yandex.ru"
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 15)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnWebsiteLabel))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    private lazy var profileInfoLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("NoInformation", comment: "")
        label.textColor = UIColor(named: "YBlackColor")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 5
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 54
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        return tableView
    }()
    
    private lazy var profileContainerView = UIView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        addSubview(profileContainerView)
        profileContainerView.addSubview(profileAvatar)
        profileContainerView.addSubview(userNameLabel)
        profileContainerView.addSubview(profileInfoLabel)
        profileContainerView.addSubview(userWebSiteLabel)
        addSubview(profileTableView)
        
        profileContainerView.translatesAutoresizingMaskIntoConstraints = false
        profileAvatar.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        userWebSiteLabel.translatesAutoresizingMaskIntoConstraints = false
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constraints.containerTop),
            profileContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.horizontalPadding),
            profileContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constraints.horizontalPadding),
            
            profileAvatar.topAnchor.constraint(equalTo: profileContainerView.topAnchor),
            profileAvatar.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor),
            profileAvatar.widthAnchor.constraint(equalToConstant: Constraints.avatarSize),
            profileAvatar.heightAnchor.constraint(equalToConstant: Constraints.avatarSize),
            
            
            userNameLabel.centerYAnchor.constraint(equalTo: profileAvatar.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: profileAvatar.trailingAnchor, constant: 16),
                 
            
            profileInfoLabel.topAnchor.constraint(equalTo: profileAvatar.bottomAnchor, constant: Constraints.infoTopSpacing),
            profileInfoLabel.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor),
            profileInfoLabel.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor),
            
            userWebSiteLabel.topAnchor.constraint(equalTo: profileInfoLabel.bottomAnchor, constant: Constraints.websiteTopSpacing),
            userWebSiteLabel.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor),
            userWebSiteLabel.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor),
            userWebSiteLabel.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor),
            
            profileTableView.topAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: Constraints.tableTopSpacing),
            profileTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileTableView.heightAnchor.constraint(equalToConstant: Constraints.tableHeight)
        ])
    }
    
    @objc private func didTapOnWebsiteLabel() {
        if let text = userWebSiteLabel.text {
            websiteLabelTapped?(text)
        }
    }
    
    func updateUI(with profile: Profile) {
        userNameLabel.text = profile.name
        
        if let avatarURLString = profile.avatar, let url = URL(string: avatarURLString) {
            profileAvatar.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
        } else {
            profileAvatar.image = UIImage(systemName: "person.crop.circle")
        }
        
        if let website = profile.website {
            let cleanedWebsite = website.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "http://", with: "")
            userWebSiteLabel.text = cleanedWebsite
        } else {
            userWebSiteLabel.isHidden = true
        }
        
        profileInfoLabel.text = profile.description ?? NSLocalizedString("NoInformation", comment: "")
        
        self.nftsCount = profile.nfts.count
        self.likesCount = profile.likes.count
        
        profileTableView.reloadData()
        
    }
    
    func updateLikesCountAndUI() {
        let likes = likesStorage.getAllLikes()
        likesCount = likes.count
        profileTableView.reloadData()
        }
}

// MARK: - UITableViewDataSource

extension ProfileView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = NSLocalizedString("MyNFT", comment: "") + " (\(nftsCount))"
        case 1:
            cell.textLabel?.text = NSLocalizedString("Favorites", comment: "") + " (\(likesCount))"
        case 2:
            cell.textLabel?.text = NSLocalizedString("AboutDeveloper", comment: "")
        default:
            break
        }
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        cell.textLabel?.textColor = UIColor(named: "YBlackColor")
        
        let chevronImage = UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .medium))?.withRenderingMode(.alwaysTemplate)
        let chevronImageView = UIImageView(image: chevronImage)
        
        cell.accessoryView = chevronImageView
        cell.tintColor = UIColor(named: "YBlackColor")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
                    if let myNFTTapped = myNFTTapped {
                        myNFTTapped()
                    }
                case 1:
                    if let favoritesTapped = favoritesTapped {
                        favoritesTapped()
                    }           case 2:
                    if let aboutDeveloper = aboutDeveloper {
                        aboutDeveloper("practicum.yandex.ru")
                    }
                default:
                    break
                }
    }
}

private extension ProfileView {
    enum Constraints {
        static let containerTop: CGFloat = 20
        static let horizontalPadding: CGFloat = 16
        static let avatarSize: CGFloat = 70
        static let infoTopSpacing: CGFloat = 20
        static let websiteTopSpacing: CGFloat = 12
        static let tableTopSpacing: CGFloat = 40
        static let tableHeight: CGFloat = 54 * 3
    }
}
