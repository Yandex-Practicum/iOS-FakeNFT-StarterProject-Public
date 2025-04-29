//
//  UserCardView.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/21/25.
//
import UIKit

protocol OpenUserWebsiteDelegate: AnyObject {
    func openUserWebsite()
}

final class UserCardView: UIView {
    // MARK: - UI Elements
    private lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stub_avatar")
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var siteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .background
        button.layer.borderColor = UIColor.segmentActive.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(.segmentActive, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.addTarget(self, action: #selector(didTapSiteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    // MARK: - Public Properties
    weak var openUserWebsiteDelegate: OpenUserWebsiteDelegate?
    // MARK: - Selectors
    @objc private func didTapSiteButton() {
        openUserWebsiteDelegate?.openUserWebsite()
    }
    // MARK: - Public Methods
    func configure() {
        backgroundColor = .background
        
        tableView.register(
            UserCardTableViewCell.self,
            forCellReuseIdentifier: UserCardTableViewCell.identifier
        )
        
        addSubview(avatar)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(siteButton)
        addSubview(tableView)
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatar.heightAnchor.constraint(equalToConstant: 70),
            avatar.widthAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 20),
            
            siteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            siteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            siteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            siteButton.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: siteButton.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func updateProfile(of user: UsersListModel) {
        if let avatarUrl = URL(string: user.avatar) {
            avatar.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "stub_avatar"))
        }
        nameLabel.text = user.name
        descriptionLabel.text = user.description
    }
}
