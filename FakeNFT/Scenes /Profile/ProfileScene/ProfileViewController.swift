//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Ivan Zhoglov on 13.01.2024.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerDelegate: AnyObject, LoadingView {
    func update()
    func showDescriptionAlert(title: String, message: String)
}

final class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Properties & UI Elements
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = Constants.cornerRadius
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: Constants.avatarPlaceholdImage)
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .sfProBold22
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .sfProRegular13
        label.textColor = .ypBlack
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var webLinkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlueUn
        label.font = .sfProRegular15
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var editButton: UIBarButtonItem = {
        let config = UIImage.SymbolConfiguration(weight: .bold)
        let button = UIBarButtonItem(
            image: UIImage(systemName: Constants.editButtonImage, withConfiguration: config),
            style: .plain,
            target: self,
            action: #selector(didTapEditButton)
        )
        return button
    }()
    
    private lazy var userStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Constants.spacingForStack
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = false
        table.separatorStyle = .none
        table.backgroundColor = .ypWhite
        table.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        return table
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
    private var nftsCount: Int = 0
    private var likesCount: Int = 0
    private var presenter: ProfileViewPresenterProtocol
    private var currentAvatar: UIImage?
    private var onImageLoaded: ((UIImage) -> Void)?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navigationItem.rightBarButtonItem = editButton
        navigationItem.rightBarButtonItem?.tintColor = .ypBlack
        addSubView()
        applyConstraint()
        setupDelegates()
        presenter.getProfile()
    }
    
    init(presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func showDescriptionAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func addSubView() {
        [avatarImage, nameLabel].forEach { userStack.addArrangedSubview($0) }
        [userStack, descriptionLabel, webLinkLabel, tableView, activityIndicator].forEach { view.addSubview($0) }
    }
    
    private func applyConstraint() {
        NSLayoutConstraint.activate([
            userStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.baseIndent),
            userStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.baseOffset),
            userStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.baseOffset),
            userStack.heightAnchor.constraint(equalToConstant: Constants.baseSize70),
            avatarImage.heightAnchor.constraint(equalToConstant: Constants.baseSize70),
            avatarImage.widthAnchor.constraint(equalToConstant: Constants.baseSize70),
            descriptionLabel.topAnchor.constraint(equalTo: userStack.bottomAnchor, constant: Constants.baseIndent),
            descriptionLabel.leadingAnchor.constraint(equalTo: userStack.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: userStack.trailingAnchor),
            webLinkLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.distance8),
            webLinkLabel.leadingAnchor.constraint(equalTo: userStack.leadingAnchor),
            webLinkLabel.trailingAnchor.constraint(equalTo: userStack.trailingAnchor),
            webLinkLabel.heightAnchor.constraint(equalToConstant: Constants.height28),
            tableView.topAnchor.constraint(equalTo: webLinkLabel.bottomAnchor, constant: Constants.distance40),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        presenter.delegate = self
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
    }
    
    // MARK: Actions
    @objc private func didTapEditButton() {
        let editProfile = EditProfileViewController(presenter: nil, avatar: currentAvatar)
        editProfile.delegate = self
        let presenterProfile = EditProfileViewPresenter(view: editProfile, profileService: presenter.profileService)
        presenterProfile.delegate = self
        editProfile.presenter = presenterProfile
        editProfile.currentProfile = presenter.model
        editProfile.modalPresentationStyle = .pageSheet
        present(editProfile, animated: true, completion: nil)
    }
    
    @objc private func labelTapped(_ gesture: UITapGestureRecognizer) {
        if let labelText = (gesture.view as? UILabel)?.text {
            var urlString = labelText
            if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
                urlString = "https://" + urlString
            }
            if let url = URL(string: urlString) {
                let webVC = WebViewController(url: url)
                webVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(webVC, animated: true)
            }
        }
    }
}

// MARK: - Table View Data Source
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfRowInSec
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileCell.identifier,
            for: indexPath) as? ProfileCell else { return UITableViewCell() }
        var name = ""
        switch indexPath.row {
        case 0:
            name = Constants.myNFT + Constants.bracket1st + String(nftsCount) + Constants.bracket2nd
        case 1:
            name = Constants.myFavorite + Constants.bracket1st + String(likesCount) + Constants.bracket2nd
        case 2:
            name = Constants.about
        default:
            break
        }
        cell.configure(with: name)
        return cell
    }
}

// MARK: - Table View Delegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            return
            // TODO: Переход на экраны Коллекции, избранных, разработчика (Эпик 3/3)
        case 1:
            return
            // TODO: Переход на экраны Коллекции, избранных, разработчика (Эпик 3/3)
        case 2:
            // временно, для перехода на работающую Web-страницу и отладки
            if let url = URL(string: "https://github.com/iamjohansson") {
                let webVC = WebViewController(url: url)
                webVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(webVC, animated: true)
            }
        default:
            break
        }
        
    }
}

// MARK: - ProfileVC Delegate
extension ProfileViewController: ProfileViewControllerDelegate {
    
    func update() {
        guard let profileModel = presenter.model else { return }
        ImageCache.default.retrieveImage(forKey: "avatarImage", options: nil) { [weak self] result in
            switch result {
            case .success(let cache):
                if let cacheImage = cache.image {
                    self?.avatarImage.image = cacheImage
                    self?.onImageLoaded?(cacheImage)
                } else {
                    if let avatar = profileModel.avatar {
                        let proc = RoundCornerImageProcessor(cornerRadius: Constants.cornerRadius)
                        self?.avatarImage.kf.indicatorType = .activity
                        self?.avatarImage.kf.setImage(with: URL(string: avatar), options: [.processor(proc)])
                    }
                }
            case .failure(let error):
                assertionFailure("Error retrieving from cache: \(error)")
            }
        }
        onImageLoaded = { [weak self] image in
            guard self?.currentAvatar != image else { return }
            self?.currentAvatar = image
        }
        self.nameLabel.text = profileModel.name
        self.descriptionLabel.text = profileModel.description
        self.webLinkLabel.text = profileModel.website
        self.nftsCount = profileModel.nfts.count
        self.likesCount = profileModel.likes.count
        self.tableView.reloadData()
    }
}

extension ProfileViewController: EditProfilePresenterDelegate {
    func profileDidUpdate(_ profile: ProfileModel) {
        presenter.saveInModel(profileModel: profile)
    }
}

extension ProfileViewController: EditProfileViewControllerDelegate {
    func didUpdateAvatar(_ newAvatar: UIImage) {
        self.avatarImage.image = newAvatar
        let cache = ImageCache.default
        cache.store(newAvatar, forKey: "avatarImage")
        self.currentAvatar = newAvatar
    }
}

// MARK: - Constants
private extension ProfileViewController {
    struct Constants {
        // Table cell
        static let myNFT = "Мой NFT "
        static let myFavorite = "Избранные NFT "
        static let about = "О разработчике"
        static let bracket1st = "("
        static let bracket2nd = ")"
        static let cellHeight: CGFloat = 54
        static let numberOfRowInSec = 3
        // Constraint
        static let baseOffset: CGFloat = 16
        static let baseSize70: CGFloat = 70
        static let baseIndent: CGFloat = 20
        static let height28: CGFloat = 28
        static let distance8: CGFloat = 8
        static let distance40: CGFloat = 40
        // UI helper
        static let editButtonImage = "square.and.pencil"
        static let avatarPlaceholdImage = "person.circle"
        static let cornerRadius: CGFloat = 35
        static let spacingForStack: CGFloat = 16
    }
}