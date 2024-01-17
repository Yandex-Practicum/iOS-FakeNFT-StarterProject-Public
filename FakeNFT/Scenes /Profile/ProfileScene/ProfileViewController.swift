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

final class ProfileViewController: UIViewController {
    
    // MARK: Properties & UI Elements
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 35
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
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(
            systemName: Constants.editButtonImage,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        )
        button.setImage(image, for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var userStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = false
        table.separatorStyle = .none
        table.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        return table
    }()
    
    private var nftsCount: Int = 0
    private var likesCount: Int = 0
    private var presenter: ProfileViewPresenterProtocol
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
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
    
    private func addSubView() {
        [avatarImage, nameLabel].forEach { userStack.addArrangedSubview($0) }
        [editButton, userStack, descriptionLabel, webLinkLabel, tableView].forEach { view.addSubview($0) }
    }
    
    private func applyConstraint() {
        NSLayoutConstraint.activate([
            editButton.heightAnchor.constraint(equalToConstant: Constants.baseSize44),
            editButton.widthAnchor.constraint(equalToConstant: Constants.baseSize44),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -7),
            userStack.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: Constants.baseIndent),
            userStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.baseOffset),
            userStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.baseOffset),
            userStack.heightAnchor.constraint(equalToConstant: Constants.baseSize70),
            avatarImage.heightAnchor.constraint(equalToConstant: Constants.baseSize70),
            avatarImage.widthAnchor.constraint(equalToConstant: Constants.baseSize70),
            descriptionLabel.topAnchor.constraint(equalTo: userStack.bottomAnchor, constant: Constants.baseIndent),
            descriptionLabel.leadingAnchor.constraint(equalTo: userStack.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: userStack.trailingAnchor),
            webLinkLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            webLinkLabel.leadingAnchor.constraint(equalTo: userStack.leadingAnchor),
            webLinkLabel.trailingAnchor.constraint(equalTo: userStack.trailingAnchor),
            webLinkLabel.heightAnchor.constraint(equalToConstant: 28),
            tableView.topAnchor.constraint(equalTo: webLinkLabel.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        presenter.delegate = self
    }
    
    // MARK: Actions
    @objc private func didTapEditButton() {
        // TODO: на экран редактирования (Эпик 2/3)
    }
}

// MARK: - Table View Data Source
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
        return 54
    }
    
    // TODO: Переход на экраны Коллекции, избранных, разработчика (Эпик 3/3)
}

extension ProfileViewController: ProfileViewControllerDelegate {
    var activityIndicator: UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        return indicator
    }
    
    func update() {
        guard let profileModel = presenter.model else { return }
        if let avatar = profileModel.avatar {
            let proc = RoundCornerImageProcessor(cornerRadius: 35)
            self.avatarImage.kf.indicatorType = .activity
            self.avatarImage.kf.setImage(with: URL(string: avatar), options: [.processor(proc)])
        }
        self.nameLabel.text = profileModel.name
        self.descriptionLabel.text = profileModel.description
        self.webLinkLabel.text = profileModel.website
        self.nftsCount = profileModel.nfts.count
        self.likesCount = profileModel.likes.count
        self.tableView.reloadData()
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
        // Constraint
        static let baseSize44: CGFloat = 44
        static let baseOffset: CGFloat = 16
        static let baseSize70: CGFloat = 70
        static let baseIndent: CGFloat = 20
        // UI helper
        static let editButtonImage = "square.and.pencil"
        static let avatarPlaceholdImage = "person.circle"
    }
}
