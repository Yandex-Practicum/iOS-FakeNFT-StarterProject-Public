import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Public properties
    
    var presenter: ProfileViewPresenterProtocol?
    
    // MARK: - Private properties
    
    private let mainStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.contentMode = .scaleAspectFit
        stack.axis = .vertical
        stack.spacing = 20
        stack.layer.masksToBounds = true
        stack.isUserInteractionEnabled = true
        return stack
    }()
    private let photoAndNameStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.contentMode = .scaleAspectFit
        stack.axis = .horizontal
        stack.spacing = 16
        stack.layer.masksToBounds = true
        return stack
    }()
    private let photoView: UIImageView = {
        let view = UIImageView()
        view.layer.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: ProfileConstants.profilePhotoSideSize,
                height: ProfileConstants.profilePhotoSideSize
            )
        )
        view.image = .userpick
        view.backgroundColor = .ypBlack
        view.layer.cornerRadius = ProfileConstants.profilePhotoSideSize/2
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .ypWhite
        return activityIndicator
    }()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .headline3
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    private let userDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .ypBlack
        textView.font = .caption2
        textView.textAlignment = .left
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        
        let lineHeightPoints: CGFloat = 18.0
        let lineHeightPixels = lineHeightPoints / UIScreen.main.scale
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeightPixels
        
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.typingAttributes = [
            .font: UIFont.caption2,
            .foregroundColor: UIColor.ypBlack,
            .paragraphStyle: paragraphStyle
        ]
        
        return textView
    }()
    private let userSiteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlueUniversal
        label.font = .caption1
        label.textAlignment = .left
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        return label
    }()
    private let tableView = UITableView()
    
    private lazy var editProfileButton: UIButton = {
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .semibold)
        let button = UIButton.systemButton(
            with: UIImage(
                systemName: "square.and.pencil",
                withConfiguration: symbolConfiguration
            ) ?? UIImage(),
            target: self,
            action: #selector(didTapEditProfileButton)
        )
        button.tintColor = .ypBlack
        return button
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openUserAboutWebView))
        userSiteLabel.addGestureRecognizer(gesture)
        addingUIElements()
        tableViewConfigure()
        layoutConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    // MARK: - Private methods
    
    private func addingUIElements() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)
        
        [editProfileButton, photoAndNameStack, userDescriptionTextView, userSiteLabel, tableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainStack.addSubview($0)
        }
        [photoView, userNameLabel, activityIndicator].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            photoAndNameStack.addSubview($0)
        }
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            editProfileButton.topAnchor.constraint(equalTo: mainStack.topAnchor),
            editProfileButton.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            
            photoAndNameStack.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 20),
            photoAndNameStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            photoAndNameStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            photoAndNameStack.heightAnchor.constraint(equalToConstant: ProfileConstants.profilePhotoSideSize),
            
            photoView.widthAnchor.constraint(equalToConstant: ProfileConstants.profilePhotoSideSize),
            photoView.heightAnchor.constraint(equalToConstant: ProfileConstants.profilePhotoSideSize),
            photoView.leadingAnchor.constraint(equalTo: photoAndNameStack.leadingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: photoView.centerYAnchor),
            
            userNameLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            userNameLabel.centerYAnchor.constraint(equalTo: photoView.centerYAnchor),
            
            userDescriptionTextView.topAnchor.constraint(equalTo: photoAndNameStack.bottomAnchor, constant: 20),
            userDescriptionTextView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            userDescriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userDescriptionTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 72),
            
            userSiteLabel.topAnchor.constraint(equalTo: photoAndNameStack.bottomAnchor, constant: 100),
            userSiteLabel.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            userSiteLabel.heightAnchor.constraint(equalToConstant: 20),
            
            tableView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: userSiteLabel.bottomAnchor, constant: 40),
            tableView.heightAnchor.constraint(equalToConstant: ProfileConstants.tableHeight),
            tableView.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor)
        ])
    }
    
    private func tableViewConfigure(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
    }
    
    private func updateTableCellsLabels(from profile: ProfileResponseModel) {
        var updatedMockArray = ProfileConstants.tableLabelArray
        
        let myNFTsCount = profile.nfts.count
        let likedNFTsCount = profile.likes.count
        
        if myNFTsCount > 0 {
            updatedMockArray[0] = "\(ProfileConstants.tableLabelArray[0]) (\(myNFTsCount))"
        }
        
        if likedNFTsCount > 0 {
            updatedMockArray[1] = "\(ProfileConstants.tableLabelArray[1]) (\(likedNFTsCount))"
        }
        
        for (index, title) in updatedMockArray.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? ProfileTableViewCell {
                cell.configure(title: title)
            }
        }
    }
    
    private func didTapMyNFTsCell() {
        guard
            let presenter = presenter,
            let profile = presenter.currentProfileResponse
        else { return }
        
        let myNFTsViewController = MyNFTsViewController()
        let myNFTsNetworkClient = NFTsNetworkClient()
        let myNFTsPresenter = MyNFTsPresenter(profile: profile)
        
        myNFTsViewController.presenter = myNFTsPresenter
        
        myNFTsPresenter.networkClient = myNFTsNetworkClient
        myNFTsPresenter.view = myNFTsViewController
        
        let navigationController = UINavigationController(rootViewController: myNFTsViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func didTapFeaturedNFTsCell() {
        guard
            let presenter = presenter,
            let profile = presenter.currentProfileResponse
        else { return }
        
        let featuredNFTsViewController = FavoriteNFTsViewController()
        let featuredNFTsNetworkClient = NFTsNetworkClient()
        let featuredNFTsPresenter = FavoriteNFTsPresenter(profile: profile)
        let profileNetworkClient = ProfileNetworkClient()
        featuredNFTsPresenter.callback = {
            presenter.viewWillAppear()
        }
        featuredNFTsViewController.presenter = featuredNFTsPresenter
        
        featuredNFTsPresenter.networkClient = featuredNFTsNetworkClient
        featuredNFTsPresenter.profileNetworkClient = profileNetworkClient
        featuredNFTsPresenter.view = featuredNFTsViewController
        
        let navigationController = UINavigationController(rootViewController: featuredNFTsViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func didTapEditProfileButton(){
        guard let profile = presenter?.editableProfile else { return }
        let profileEditPresenter = ProfileEditPresenter(editableProfile: profile)
        let profileEditViewController = ProfileEditViewController(editableProfile: profile)
        profileEditViewController.presenter = profileEditPresenter
        profileEditViewController.delegate = self
        present(profileEditViewController, animated: true)
    }
    
    @objc private func openUserAboutWebView() {
        guard let url = presenter?.currentProfileResponse?.website else { return }
        let presenter = WebViewPresenter(url: url)
        let webView = UserAboutWebView()
        webView.presenter = presenter
        presenter.view = webView
        present(webView, animated: true)
    }
}


// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            didTapMyNFTsCell()
        case 1:
            didTapFeaturedNFTsCell()
        case 2:
            openUserAboutWebView()
        default:
            print("Uncknown row")
        }
    }
}


// MARK: - Extension UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ProfileConstants.tableLabelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileTableViewCell = tableView.dequeueReusableCell()
        cell.configure(title: ProfileConstants.tableLabelArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ProfileConstants.tableCellHeight
    }
}


// MARK: - Extension ProfileViewControllerProtocol

extension ProfileViewController: ProfileViewControllerProtocol{
    func activityIndicatorAnimation(inProcess: Bool){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if inProcess {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func setImageForPhotoView(_ image: UIImage) {
        photoView.image = image
    }
    
    func setTextForLabels(from profile: ProfileResponseModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.userDescriptionTextView.text = profile.description
            self.userNameLabel.text = profile.name
            self.userSiteLabel.text = profile.website.absoluteString
            self.updateTableCellsLabels(from: profile)
        }
    }
}

// MARK: - Extension ProfileViewDelegate

extension ProfileViewController: ProfileViewDelegate {
    func sendNewProfile(_ profile: ProfileResponseModel) {
        DispatchQueue.main.async {
            self.presenter?.updateProfile(with: profile)
        }
    }
    
    func showNetworkErrorAlert(with error: Error) {
        if presentedViewController is UIAlertController { return }
        
        let alertMessage = ("\(NSLocalizedString("nft.error.message", comment: ""))\n\(error)")
        
        let alert = UIAlertController(
            title: NSLocalizedString("nft.error.title", comment: ""),
            message: alertMessage,
            preferredStyle: .alert)
        
        let repeatAction = UIAlertAction(
            title: NSLocalizedString("profile.photo.retryButton", comment: ""),
            style: .default
        ) { _ in
            self.presenter?.viewWillAppear()
        }
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("profile.photo.cancelButton", comment: ""),
            style: .cancel
        )
        alert.addAction(repeatAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}
