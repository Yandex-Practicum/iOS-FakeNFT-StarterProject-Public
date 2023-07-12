import UIKit
import Kingfisher

final class ProfileView: UIView {
    
    // MARK: - Properties
    private var viewModel: ProfileViewModel
    private var viewController: ProfileViewController
    private var assetViewControllers: [UIViewController] = []
    
    private lazy var assetLabel: [String] = [
        "Мои NFT",
        "Избранные NFT",
        "О разработчике"
    ]
    
    private lazy var assetValue: [String?] = [
        "(\(viewModel.nfts?.count ?? 0))",
        "(\(viewModel.likes?.count ?? 0))",
        nil
    ]
    
    //MARK: - Layout elements
    private lazy var avatarImage: UIImageView = {
        let placeholder = UIImage(named: "UserImagePlaceholder")
        let avatarImage = UIImageView(image: placeholder)
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.accessibilityIdentifier = "avatarImage"
        avatarImage.layer.cornerRadius = 35
        avatarImage.layer.masksToBounds = true
        return avatarImage
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.accessibilityIdentifier = "nameLabel"
        nameLabel.text = ""
        nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nameLabel.textColor = .black
        return nameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.accessibilityIdentifier = "descriptionLabel"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 18
        descriptionLabel.attributedText = NSAttributedString(string: "", attributes: [.kern: 0.08, NSAttributedString.Key.paragraphStyle : paragraphStyle])
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .black
        return descriptionLabel
    }()
    
    private lazy var websiteLabel: UILabel = {
        let websiteLabel = UILabel()
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteLabel.accessibilityIdentifier = "websiteLabel"
        let tapAction = UITapGestureRecognizer(target: self, action:#selector(websiteDidTap(_:)))
        websiteLabel.isUserInteractionEnabled = true
        websiteLabel.addGestureRecognizer(tapAction)
        websiteLabel.attributedText = NSAttributedString(string: "", attributes: [.kern: 0.24])
        websiteLabel.font = UIFont.systemFont(ofSize: 15)
        websiteLabel.textColor = .blue
        return websiteLabel
    }()
    
    private lazy var profileAssetsTable: UITableView = {
        let profileAssetsTable = UITableView()
        profileAssetsTable.translatesAutoresizingMaskIntoConstraints = false
        profileAssetsTable.accessibilityIdentifier = "profileAssetsTable"
        profileAssetsTable.register(ProfileAssetsCell.self)
        profileAssetsTable.dataSource = self
        profileAssetsTable.delegate = self
        profileAssetsTable.separatorStyle = .none
        profileAssetsTable.allowsMultipleSelection = false
        return profileAssetsTable
    }()
    
    // MARK: - Lifecycle
    init(frame: CGRect, viewModel: ProfileViewModel, viewController: ProfileViewController) {
        self.viewModel = viewModel
        self.viewController = viewController
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        addUserImage()
        addUsernameLabel()
        addDescriptionLabel()
        addWebsiteLabel()
        addProfileAssetsTable()
        
        let myNFTViewController = MyNFTViewController(nftIDs: viewModel.nfts ?? [], likedIDs: viewModel.likes ?? [])
        let favoritesViewController = FavoritesViewController(likedIDs: viewModel.likes ?? [])
        let developersViewController = DevelopersViewController()
        
        assetViewControllers = [myNFTViewController, favoritesViewController, developersViewController]
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(likesUpdated),
            name: NSNotification.Name(rawValue: "likesUpdated"),
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc
    private func websiteDidTap(_ sender: UITapGestureRecognizer) {
        viewController.present(WebsiteViewController(webView: nil, websiteURL: websiteLabel.text), animated: true)
    }
    
    func updateViews(
        avatarURL: URL?,
        userName: String?,
        description: String?,
        website: String?,
        nftCount: String?,
        likesCount: String?
    ) {
        avatarImage.kf.setImage(
            with: avatarURL,
            placeholder: UIImage(named: "UserImagePlaceholder"),
            options: [.processor(RoundCornerImageProcessor(cornerRadius: 35))])
        nameLabel.text = userName
        descriptionLabel.text = description
        websiteLabel.text = website
    }
    
    @objc
    private func likesUpdated(notification: Notification) {
        guard let likesUpdated = notification.object as? Int else { return }
        let cell = profileAssetsTable.cellForRow(at: [0,1]) as? ProfileAssetsCell
        cell?.setAssets(label: nil, value: "(\(likesUpdated))")
    }
    
    //MARK: - Layout methods
    private func addUserImage() {
        self.addSubview(avatarImage)
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func addUsernameLabel() {
        self.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor, constant: 21).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16).isActive = true
    }
    
    private func addDescriptionLabel() {
        self.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 20),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func addWebsiteLabel() {
        self.addSubview(websiteLabel)
        NSLayoutConstraint.activate([
            websiteLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            websiteLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
        ])
    }
    
    private func addProfileAssetsTable() {
        self.addSubview(profileAssetsTable)
        NSLayoutConstraint.activate([
            profileAssetsTable.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 40),
            profileAssetsTable.heightAnchor.constraint(equalToConstant: 54 * 3),
            profileAssetsTable.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileAssetsTable.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

// MARK: - Extensions
extension ProfileView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileAssetsCell = tableView.dequeueReusableCell()
        cell.backgroundColor = .white
        cell.setAssets(label: assetLabel[indexPath.row], value: assetValue[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

extension ProfileView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewController.navigationController?.pushViewController(self.assetViewControllers[indexPath.row], animated: true)
    }
}
