import UIKit

final class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    private let viewModel: ProfileViewModelProtocol
    
    private lazy var assetNameLabel: [String] = [
        "Мои NFT",
        "Избранные NFT",
        "О разработчике"
    ]
    
    private lazy var assetValue: [String?] = [
        "\(viewModel.profile?.nfts.count ?? 0)",
        "\(viewModel.profile?.likes.count ?? 0)",
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
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
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
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupConstraints()
        view.backgroundColor = .appWhite
        setupNavBar()
        UIBlockingProgressHUD.show()
        viewModel.getProfileData()
        UIBlockingProgressHUD.dismiss()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(likesUpdated),
            name: NSNotification.Name(rawValue: "likesUpdated"),
            object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func updateViews(
        profile: ProfileModel?
    ) {
        avatarImage.loadImage(
            urlString: profile?.avatar,
            placeholder: UIImage.Icons.userPlaceholder,
            radius: 35
        )
        nameLabel.text = profile?.name
        descriptionLabel.text = profile?.description
        websiteLabel.text = profile?.website
        
        let stringNftsCount = "(\(profile?.nfts.count ?? 0))"
        let stringLikesCount = "(\(profile?.likes.count ?? 0))"
        
        let myNFTCell = profileAssetsTable.cellForRow(at: [0,0]) as? ProfileAssetsCell
        myNFTCell?.setAssets(label: nil, value: stringNftsCount)
        
        let likesCell = profileAssetsTable.cellForRow(at: [0,1]) as? ProfileAssetsCell
        likesCell?.setAssets(label: nil, value: stringLikesCount)
    }
    
    @objc
    private func websiteDidTap(_ sender: UITapGestureRecognizer) {
        self.present(WebsiteViewController(link: viewModel.profile?.website), animated: true)
    }
    
    @objc
    private func likesUpdated(notification: Notification) {
        guard let likesUpdated = notification.object as? Int else { return }
        let cell = profileAssetsTable.cellForRow(at: [0,1]) as? ProfileAssetsCell
        cell?.setAssets(label: nil, value: "(\(likesUpdated))")
    }
    
    private func bind() {
        if viewModel.isCheckConnectToInternet() {
            viewModel.onChange = { [weak self] in
                self?.updateViews(profile: self?.viewModel.profile)
            }
        } else {
            viewModel.onError = { [weak self] in
                UIBlockingProgressHUD.dismiss()
                self?.view = NoContentView(frame: .zero, noContent: .noInternet)
                self?.navigationController?.navigationBar.isHidden = true
            }
        }
        
    }
    
    private func setupNavBar() {
        (navigationController as? NavigationController)?.editProfileButtonDelegate = self
        navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupConstraints() {
        [avatarImage, nameLabel, descriptionLabel, websiteLabel, profileAssetsTable].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor, constant: 21),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 20),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            websiteLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            websiteLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            
            profileAssetsTable.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 40),
            profileAssetsTable.heightAnchor.constraint(equalToConstant: 54 * 3),
            profileAssetsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileAssetsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
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

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let profile = viewModel.profile else { return }
        switch indexPath.row {
        case 0:
            let viewController = MyNFTViewController(viewModel: MyNFTViewModel(profile: profile))
            navigationController?.pushViewController(viewController, animated: true)
        case 1:
            let networkClient = DefaultNetworkClient()
            let viewModel = FavoritesViewModel(networkClient:networkClient, profile: profile)
            let viewController = FavoritesViewController(viewModel: viewModel)
            navigationController?.pushViewController(viewController, animated: true)
        case 2:
            let viewController = WebsiteViewController()
            navigationController?.pushViewController(viewController, animated: true)
        default:
            return
        }
    }
}

// MARK: - EditProfileButtonDelegate
extension ProfileViewController: EditProfileButtonDelegate {
    func proceedToEditing() {
        guard let profile = viewModel.profile else { return }
        let viewModel = EditProfileViewModel(networkClient: DefaultNetworkClient(), profile: profile)
        let viewController = EditProfileViewController(viewModel: viewModel, delegate: self)
        present(viewController, animated: true)
    }
}

// MARK: - ProfileUpdateDelegate
extension ProfileViewController: ProfileUpdateDelegate {
    func update() {
        viewModel.getProfileData()
        bind()
        UIBlockingProgressHUD.dismiss()
    }
}
