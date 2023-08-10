import UIKit
import Kingfisher

final class ProfileView: UIView {
    private let viewModel: ProfileViewModelProtocol
    private let viewController: ProfileViewController
    private var assetViewControllers: [UIViewController] = []
    
    private lazy var assetNameLabel: [String] = [
        "Мои NFT",
        "Избранные NFT",
        "О разработчике"
    ]
    
    private lazy var assetValue: [String?] = [
        "\(viewModel.nfts?.count ?? 0)",
        "\(viewModel.likes?.count ?? 0)",
        nil
    ]
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView(image: UIImage.Icons.userPlaceholder)
        imageView.accessibilityIdentifier = "avatarImage"
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "nameLabel"
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .appBlack
        return label
    }()
    
    private lazy var descriptionLabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "descriptionLabel"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 18
        label.attributedText = NSAttributedString(string: "", attributes: [.kern: 0.68, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.textColor = .appBlack
        return label
    }()
    
    private lazy var websiteLabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "websiteLabel"
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(websiteDidTap))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapAction)
        label.attributedText = NSAttributedString(string: "", attributes: [.kern: 0.24])
        label.font = .systemFont(ofSize: 15)
        label.textColor = .appBlue
        return label
    }()
    
    private lazy var profileAssetsTable = {
        let tableView = UITableView()
        tableView.accessibilityIdentifier = "profileTable"
        tableView.register(ProfileAssetsCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        return tableView
    }()
    
    init(frame: CGRect, viewModel: ProfileViewModelProtocol, viewController: ProfileViewController) {
        self.viewModel = viewModel
        self.viewController = viewController
        super.init(frame: .zero)
        
        self.backgroundColor = .appWhite
        setupConstraints()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(likesUpdated),
            name: NSNotification.Name(rawValue: "likesUpdated"),
            object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialViewControllers() {
        //TODO: - сделать инициализацию
        let myNFTViewController = NyNFTViewController(nftIDs: viewModel.nfts ?? [], likedIDs: viewModel.likes ?? [])
        let favoritesViewController = FavoritesViewController(likedIDs: viewModel.likes ?? [])
        let developersViewController = DevelopersViewController()

        assetViewControllers = [myNFTViewController, favoritesViewController, developersViewController]
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
            placeholder: UIImage.Icons.userPlaceholder,
            options: [.processor(RoundCornerImageProcessor(cornerRadius: 35))])
        nameLabel.text = userName
        descriptionLabel.text = description
        websiteLabel.text = website
        
        let myNFTCell = profileAssetsTable.cellForRow(at: [0,0]) as? ProfileAssetsCell
        myNFTCell?.setAssets(label: nil, value: nftCount)
        
        let likesCell = profileAssetsTable.cellForRow(at: [0,1]) as? ProfileAssetsCell
        likesCell?.setAssets(label: nil, value: likesCount)
    }
    
    @objc
    private func websiteDidTap(_ sender: UITapGestureRecognizer) {
        viewController.present(WebsiteViewController(websiteURL: websiteLabel.text), animated: true)
    }
    
    @objc
    private func likesUpdated(notification: Notification) {
        guard let likesUpdated = notification.object as? Int else { return }
        let cell = profileAssetsTable.cellForRow(at: [0,1]) as? ProfileAssetsCell
        cell?.setAssets(label: nil, value: "(\(likesUpdated))")
    }
    
    private func setupConstraints() {
        [avatarImage, nameLabel, descriptionLabel, websiteLabel, profileAssetsTable].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor, constant: 21),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 20),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            websiteLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            websiteLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            
            profileAssetsTable.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 40),
            profileAssetsTable.heightAnchor.constraint(equalToConstant: 54 * 3),
            profileAssetsTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileAssetsTable.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension ProfileView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetNameLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileAssetsCell = tableView.dequeueReusableCell()
        cell.backgroundColor = .appWhite
        cell.setAssets(label: assetNameLabel[indexPath.row], value: assetValue[indexPath.row])
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
