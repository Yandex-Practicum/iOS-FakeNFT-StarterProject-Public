import UIKit
import SafariServices

//MARK: - UserCardViewController
final class UserCardViewController: UIViewController {
    
    private var userCardFabric: UserCardFabric
    private var servicesAssembly: ServicesAssembly
    
    private lazy var backwardButton: UIBarButtonItem = {
        let sortButton = UIBarButtonItem(title: "",
                                         style: .plain,
                                         target: self,
                                         action: #selector(backwardButtonAction))
        sortButton.image = UIImage(resource: .backward).withTintColor(UIColor(resource: .ypBlack), renderingMode: .alwaysOriginal)
        return sortButton
    }()
    
    //MARK: userCardStackView
    private lazy var userCardStackView: UIStackView = {
        let userCardStackView = UIStackView()
        userCardStackView.axis = .vertical
        userCardStackView.spacing = 20
        userCardStackView.distribution = .fillEqually
        return userCardStackView
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let userInfoStackView = UIStackView()
        userInfoStackView.axis = .horizontal
        userInfoStackView.spacing = 16
        return userInfoStackView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        return avatarImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.sfProBold22
        return nameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.sfProRegular13
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    //MARK: userWebsiteButton
    private lazy var userWebsiteButton: UIButton = {
        let userWebsiteButton = UIButton()
        userWebsiteButton.titleLabel?.font = UIFont.sfProRegular15
        userWebsiteButton.layer.cornerRadius = 16
        userWebsiteButton.layer.masksToBounds = true
        userWebsiteButton.layer.borderWidth = 1
        userWebsiteButton.setTitleColor(UIColor(resource: .ypBlack), for: .normal)
        userWebsiteButton.layer.borderColor = UIColor(resource: .ypBlack).cgColor
        userWebsiteButton.setTitle(NSLocalizedString("Statistic.userCard.transitToUserWebsite", comment: ""), for: .normal)
        userWebsiteButton.addTarget(self, action: #selector(userWebsiteButtonAction), for: .touchUpInside)
        return userWebsiteButton
    }()
    
    //MARK: showCollectionStackView
    private lazy var showCollectionStackView: UIStackView = {
        let showCollectionStackView = UIStackView()
        showCollectionStackView.axis = .horizontal
        
        return showCollectionStackView
    }()
    
    private lazy var collectionLabel: UILabel = {
        let collectionLabel = UILabel()
        collectionLabel.font = UIFont.sfProBold17
        collectionLabel.text = NSLocalizedString("Statistic.userCard.collectionOfNft", comment: "")
        return collectionLabel
    }()
    
    private lazy var countOfNftLabel: UILabel = {
        let countOfNftLabel = UILabel()
        countOfNftLabel.font = UIFont.sfProBold17
        return countOfNftLabel
    }()
    
    private lazy var forwardButton: UIImageView = {
        let forwardButton = UIImageView()
        forwardButton.image = UIImage(systemName: "chevron.forward")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return forwardButton
    }()
    
    //MARK: init
    init(user: UsersModel, servicesAssembly: ServicesAssembly) {
        self.userCardFabric = UserCardFabric(with: user)
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        activateUI()
        loadData()
    }
    
    //MARK: objc Methods
    @objc
    private func backwardButtonAction() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func userWebsiteButtonAction() {
        guard let url = getWebsiteUser() else { return }
        let vcToPresent = SFSafariViewController(url: url)
        navigationController?.present(vcToPresent, animated: true)
    }
    
    @objc
    private func showUsersCollectionOfNft() {
        let nfts = userCardFabric.getNfts()
        print(nfts)
        let vc = CollectionOfUsersNftViewController(
            with: nfts,
            servicesAssembly: servicesAssembly)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - NavigationController
extension UserCardViewController {
    
    func setupNavigation() {
        
        navigationController?.view.backgroundColor = UIColor(resource: .ypWhite)
        navigationController?.modalPresentationStyle = .popover
        navigationItem.leftBarButtonItem = backwardButton
    }
}

// MARK: - Add UI-Elements on View
extension UserCardViewController {
    
    func activateUI() {
        
        view.backgroundColor = UIColor(resource: .ypWhite)
        activateConstraint()
        addTargetForStackView()
    }
    
    func activateConstraint() {
        //MARK: - Add Views
        //MARK: Base View
        [userCardStackView, userWebsiteButton, showCollectionStackView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //MARK: userCardStackView
        [userInfoStackView, descriptionLabel].forEach {
            userCardStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //MARK: userInfoStackView
        [avatarImageView, nameLabel].forEach {
            userInfoStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //MARK: showCollectionStackView
        [collectionLabel, countOfNftLabel, forwardButton].forEach {
            showCollectionStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //MARK: - Setup Constraints
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            //MARK: userCardStackView
            userCardStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            userCardStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            userCardStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            
            //MARK: userWebsiteButton
            userWebsiteButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            userWebsiteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            userWebsiteButton.topAnchor.constraint(equalTo: userCardStackView.bottomAnchor, constant: 28),
            userWebsiteButton.heightAnchor.constraint(equalToConstant: 40),
            
            //MARK: showCollectionStackView
            showCollectionStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            showCollectionStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            showCollectionStackView.topAnchor.constraint(equalTo: userWebsiteButton.bottomAnchor, constant: 56),
            showCollectionStackView.heightAnchor.constraint(equalToConstant: 22),
            
            //MARK: userInfoStackView
            userInfoStackView.leadingAnchor.constraint(equalTo: userCardStackView.leadingAnchor, constant: 16),
            userInfoStackView.trailingAnchor.constraint(equalTo: userCardStackView.trailingAnchor, constant: -16),
            userInfoStackView.topAnchor.constraint(equalTo: userCardStackView.topAnchor),
            userInfoStackView.heightAnchor.constraint(equalToConstant: 70),
            
            //MARK: descriptionLabel
            descriptionLabel.leadingAnchor.constraint(equalTo: userCardStackView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: userCardStackView.trailingAnchor, constant: -16),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 70),
            
            //MARK: avatarImageView
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: userInfoStackView.leadingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: userInfoStackView.topAnchor),
            
            //MARK: nameLabel
            nameLabel.centerYAnchor.constraint(equalTo: userInfoStackView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: userInfoStackView.trailingAnchor),
            
            //MARK: collectionLabel
            collectionLabel.centerYAnchor.constraint(equalTo: showCollectionStackView.centerYAnchor),
            collectionLabel.leadingAnchor.constraint(equalTo: showCollectionStackView.leadingAnchor),
            
            //MARK: countOfNftLabel
            countOfNftLabel.centerYAnchor.constraint(equalTo: showCollectionStackView.centerYAnchor),
            countOfNftLabel.leadingAnchor.constraint(equalTo: collectionLabel.trailingAnchor, constant: 8),
            
            //MARK: forwardButton
            forwardButton.heightAnchor.constraint(equalToConstant: 22),
            forwardButton.centerYAnchor.constraint(equalTo: showCollectionStackView.centerYAnchor),
            forwardButton.trailingAnchor.constraint(equalTo: showCollectionStackView.trailingAnchor)
        ])
    }
    
    func addTargetForStackView() {
        
        showCollectionStackView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showUsersCollectionOfNft))
        showCollectionStackView.addGestureRecognizer(tapGesture)
    }
}

//MARK: - Load Data
extension UserCardViewController: UserCardProtocol {
    
    func loadData() {
        
        getAvatar()
        getName()
        getDescription()
        getCountOfNft()
    }
    
    @discardableResult
    func getAvatar() -> URL? {
        
        let placeholderAvatar = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(UIColor(resource: .ypGrayUn), renderingMode: .alwaysOriginal)
        
        let avatarUrl = userCardFabric.getAvatar()
        avatarImageView.kf.setImage(with: avatarUrl, placeholder: placeholderAvatar)
        return avatarUrl
    }
    
    @discardableResult
    func getName() -> String {
        
        let nameUser = userCardFabric.getName()
        nameLabel.text = nameUser
        return nameUser
    }
    
    @discardableResult
    func getDescription() -> String {
        
        let descriptionUser = userCardFabric.getDescription()
        descriptionLabel.text = descriptionUser
        return descriptionUser
    }
    
    @discardableResult
    func getCountOfNft() -> String {
        
        let countOfNft = userCardFabric.getCountOfNft()
        countOfNftLabel.text = (" \(countOfNft)")
        return countOfNft
    }
    
    func getWebsiteUser() -> URL? {
        
        userCardFabric.getWebsiteUser()
    }
}
