//
//  UserCardViewController.swift
//  FakeNFT
//

import UIKit

final class UserCardViewController: UIViewController {
    private lazy var userImageView: UIImageView = {
        let pic = UIImage(systemName: "person.crop.circle.fill")
        let image = UIImageView(image: pic)
        image.layer.cornerRadius = 35
        image.clipsToBounds = true
        image.tintColor = .nftGrayUniversal
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline2
        label.textColor = .nftBlack
        label.text = "Joaquin Phoenix"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .nftBlack
        label.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var userInfoButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.nftBlack.cgColor
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(.nftBlack, for: .normal)
        button.titleLabel?.font = .caption1
        button.addTarget(self, action: #selector(goToWebView), for: .touchUpInside)
        return button
    }()
    
    private lazy var userCollectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Коллекция NFT " + "(\(333))", for: .normal)
        button.setTitleColor(.nftBlack, for: .normal)
        button.titleLabel?.font = .bodyBold
        button.addTarget(self, action: #selector(goToCollection), for: .touchUpInside)
        return button
    }()

    private lazy var chevronImage: UIImageView = {
        let pic = UIImage(named: "chevron.forward")
        let image = UIImageView(image: pic)
        image.tintColor = .nftBlack
        return image
    }()
    
    var users: User?
// MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
// MARK: - Actions
    @objc
    private func goToWebView() {
        //TODO: вставить переход на webview
    }
    
    @objc
    private func goToCollection() {
        let usersCollection = UserCollectionViewController()
        usersCollection.title = "Коллекция NFT"
        navigationController?.pushViewController(usersCollection, animated: true)
    }
// MARK: - setupUI
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil,
                                                        action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        navigationController?.navigationBar.tintColor = .nftBlack
    }

    private func setupUI() {
        [userImageView, nameLabel, descriptionLabel, userInfoButton, userCollectionButton, chevronImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        view.backgroundColor = .nftWhite
// MARK: - AutoLayouts
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userImageView.heightAnchor.constraint(equalToConstant: 70),
            userImageView.widthAnchor.constraint(equalToConstant: 70),
            
            nameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            userInfoButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            userInfoButton.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            userInfoButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            userInfoButton.heightAnchor.constraint(equalToConstant: 40),
            
            userCollectionButton.topAnchor.constraint(equalTo: userInfoButton.bottomAnchor, constant: 40),
            userCollectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userCollectionButton.heightAnchor.constraint(equalToConstant: 54),
            
            chevronImage.centerYAnchor.constraint(equalTo: userCollectionButton.centerYAnchor),
            chevronImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
