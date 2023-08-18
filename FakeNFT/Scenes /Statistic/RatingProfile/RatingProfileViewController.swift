//
//  RatingProfileViewController.swift
//  FakeNFT
//
//  Created by macOS on 21.06.2023.
//

import UIKit
import ProgressHUD

final class RatingProfileViewController: UIViewController {
    
    private let userId: Int
    private var user: User? = nil

    private let viewModel = RatingProfileViewModel()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backIcon"), for: .normal)
        button.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .YPBlack
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .YPBlack
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var websiteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.YPBlack.cgColor
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(.YPBlack, for: .normal)
        button.titleLabel?.font = .caption1
        button.addTarget(self, action: #selector(navigateToWebsite), for: .touchUpInside)
        return button
    }()
    
    private lazy var nftCollectionContainer: UIView = {
        let view = UIView()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigateToCollection))
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()
    
    private lazy var nftCollectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Коллекция NFT"
        label.font = .bodyBold
        label.textColor = .YPBlack
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var nftCollectionCountLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .YPBlack
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var forwardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "forwardIcon")
        return imageView
    }()
    
    init(userId: Int) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        
        addViews()
        setUpConstraints()
        
        bind()
        viewModel.getUser(userId: userId)
    }
    
    private func bind() {
        viewModel.$user.bind { [weak self] user in
            if let user = user {
                self?.updateUserInfo(user: user)
            } else {
                self?.presentErrorDialog(message: nil)
            }
        }
        viewModel.$errorMessage.bind { [weak self] errorMessage in
            self?.presentErrorDialog(message: errorMessage)
        }
        viewModel.$isLoading.bind { isLoading in
            if isLoading {
                ProgressHUD.show()
            } else {
                ProgressHUD.dismiss()
            }
        }
    }
    
    private func updateUserInfo(user: User) {
        self.user = user
        nameLabel.text = user.name
        descriptionLabel.text = user.description
        nftCollectionCountLabel.text = "(\(user.nfts.count))"
        
        if let url = URL(string: user.avatar) {
            avatarImageView.loadImage(url: url, cornerRadius: 100)
        }
    }
    
    @objc private func navigateBack() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func navigateToWebsite() {
        if let websiteUrl = user?.website,
           let websiteUrl = URL(string: websiteUrl) {
            let vc = WebsiteProfileViewController()
            vc.websiteUrl = websiteUrl
            navigationController?.pushViewController(vc, animated: true)
        } else {
            presentErrorDialog(message: nil)
        }
    }
    
    @objc private func navigateToCollection() {
        guard let user = user else {
            presentErrorDialog(message: nil)
            return
        }
        
        if user.nfts.isEmpty {
            presentErrorDialog(message: "Коллекция пуста")
        } else {
            let vc = ProfileCollectionViewController()
            vc.nftIds = user.nfts.map { Int($0) ?? 0 }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func addViews() {
        view.addSubview(backButton)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(websiteButton)
        view.addSubview(nftCollectionContainer)
        nftCollectionContainer.addSubview(nftCollectionLabel)
        nftCollectionContainer.addSubview(nftCollectionCountLabel)
        nftCollectionContainer.addSubview(forwardImageView)
    }
    
    private func setUpConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteButton.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionContainer.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionCountLabel.translatesAutoresizingMaskIntoConstraints = false
        forwardImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 29),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            websiteButton.heightAnchor.constraint(equalToConstant: 40),
            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            websiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            nftCollectionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionContainer.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 40),
            nftCollectionContainer.heightAnchor.constraint(equalToConstant: 54),
            
            nftCollectionLabel.topAnchor.constraint(equalTo: nftCollectionContainer.topAnchor, constant: 16),
            nftCollectionLabel.bottomAnchor.constraint(equalTo: nftCollectionContainer.bottomAnchor, constant: -16),
            nftCollectionLabel.leadingAnchor.constraint(equalTo: nftCollectionContainer.leadingAnchor, constant: 0),
            
            nftCollectionCountLabel.topAnchor.constraint(equalTo: nftCollectionContainer.topAnchor, constant: 16),
            nftCollectionCountLabel.bottomAnchor.constraint(equalTo: nftCollectionContainer.bottomAnchor, constant: -16),
            nftCollectionCountLabel.leadingAnchor.constraint(equalTo: nftCollectionLabel.trailingAnchor, constant: 8),
            
            forwardImageView.widthAnchor.constraint(equalToConstant: 8),
            forwardImageView.heightAnchor.constraint(equalToConstant: 14),
            forwardImageView.centerYAnchor.constraint(equalTo: nftCollectionContainer.centerYAnchor),
            forwardImageView.trailingAnchor.constraint(equalTo: nftCollectionContainer.trailingAnchor)
        ])
    }
    
}
