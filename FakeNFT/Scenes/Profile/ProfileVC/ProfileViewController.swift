import UIKit
import Kingfisher

protocol ProfileViewControllerDelegate: AnyObject {
    func updateProfile(profile: Profile)
}

final class ProfileViewController: UIViewController {

    // MARK: - Properties

    private var viewModel: ProfileViewModelProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupNavBar()
        setupConstrains()
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isNavigationBarClear(true)
        blockUI(withBlur: true)
        viewModel?.fetchProfile()
    }

    // MARK: - Init

    init(viewModel: ProfileViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    
    private func setupBackground() {
        view.backgroundColor = .ypWhiteWithDarkMode
        view.tintColor = .ypBlackWithDarkMode
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Resources.Images.editProfile,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(presentEditVC))
    }
    
    private lazy var profileAvatarImage: UIImageView = {
        var profileAvatarImage = UIImageView()
        profileAvatarImage.backgroundColor = .lightGray
        profileAvatarImage.layer.cornerRadius = 35
        profileAvatarImage.clipsToBounds = true
        profileAvatarImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileAvatarImage)
        return profileAvatarImage
    }()
    
    private lazy var profileNameLabel: UILabel = {
        let profileNameLabel = UILabel()
        profileNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.07
        profileNameLabel.numberOfLines = 2
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileNameLabel)
        return profileNameLabel
    }()
    
    private lazy var profileDescriptionLabel: UILabel = {
        let profileDescriptionLabel = UILabel()
        profileDescriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        let attributedText = NSMutableAttributedString(string: profileDescriptionLabel.text ?? "")
        let paragrapthStyle = NSMutableParagraphStyle()
        paragrapthStyle.lineSpacing = 5
        attributedText.addAttribute(.paragraphStyle, value: paragrapthStyle, range: NSRange(location: 0, length: attributedText.length))
        profileDescriptionLabel.attributedText = attributedText
        profileDescriptionLabel.numberOfLines = 0
        profileDescriptionLabel.lineBreakMode = .byWordWrapping
        profileDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileDescriptionLabel)
        return profileDescriptionLabel
    }()
    
    private lazy var profileSite: UILabel = {
        let profileSite = UILabel()
        profileSite.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        profileSite.textColor = .ypBlue
        profileSite.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileSite)
        return profileSite
    }()
    
    private lazy var profileTableView: UITableView = {
        let profileTableView = UITableView()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.separatorStyle = .none
        profileTableView.isScrollEnabled = false
        profileTableView.backgroundColor = .clear
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileTableView)
        return profileTableView
    }()
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            profileAvatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileAvatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileAvatarImage.widthAnchor.constraint(equalToConstant: 70),
            profileAvatarImage.heightAnchor.constraint(equalToConstant: 70),
            
            profileNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImage.trailingAnchor, constant: 16),
            profileNameLabel.centerYAnchor.constraint(equalTo: profileAvatarImage.centerYAnchor),
            profileNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            profileDescriptionLabel.topAnchor.constraint(equalTo: profileAvatarImage.bottomAnchor, constant: 20),
            profileDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            profileSite.topAnchor.constraint(equalTo: profileDescriptionLabel.bottomAnchor, constant: 12),
            profileSite.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileSite.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            profileTableView.topAnchor.constraint(equalTo: profileSite.bottomAnchor, constant: 40),
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupProfile() {
        DispatchQueue.main.async { [weak self] in
            guard let self,
                  let profile = self.viewModel?.profileObservable.wrappedValue,
            let avatarUrl = URL(string: profile.avatar) else { return }
            self.profileNameLabel.text = profile.name
            self.profileDescriptionLabel.text = profile.description
            self.profileSite.text = profile.website
            self.profileAvatarImage.kf.setImage(with: avatarUrl)
            self.profileTableView.reloadData()
        }
    }
    
    private func setUpBindings() {
        viewModel?.profileObservable.bind(action: { [weak self] _ in
            guard let self else { return }
            self.resumeMethodOnMainThread(self.unblockUI, with: ())
            self.resumeMethodOnMainThread(self.isNavigationBarClear, with: false)
            self.setupProfile()
        })
        
        viewModel?.showErrorAlert = { [weak self] message in
            guard let self else { return }
            self.resumeMethodOnMainThread(self.unblockUI, with: ())
            self.resumeMethodOnMainThread(self.isNavigationBarClear, with: false)
            self.resumeMethodOnMainThread(self.showNotificationBanner, with: message)
        }
    }
    
    // MARK: - Actions
    
    @objc func presentEditVC() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.profile = viewModel?.profileObservable.wrappedValue
        editProfileViewController.delegate = self
        present(editProfileViewController, animated: true)
    }
}

    // MARK: - UITableViewDelegate&UITableViewDataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: Resources.Images.forwardButtonImage)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        let profile = viewModel?.profileObservable.wrappedValue
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = NSLocalizedString("profile.mainScreen.myNFT", tableName: "Localizable", comment: "My NFT") + " (\(profile?.nfts.count ?? 0))"
        case 1:
            cell.textLabel?.text = NSLocalizedString("profile.mainScreen.favouritesNFT", tableName: "Localizable", comment: "Favourite NFT") + " (\(profile?.likes.count ?? 0))"
        case 2:
            cell.textLabel?.text = NSLocalizedString("profile.mainScreen.aboutDeveloper", tableName: "Localizable", comment: "About Developer")
        default:
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let myNFTViewModel = MyNFTViewModel(dataProvider: ProfileDataProvider())
            let myNftsVC = MyNftsViewController(viewModel: myNFTViewModel)
            myNftsVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(myNftsVC, animated: true)
        case 1:
           //TODO: set up favoureite Nfts VC
            let favouriteNftsVC = FavouriteNftsViewController()
            favouriteNftsVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(favouriteNftsVC, animated: true)
        case 2:
            guard let url = URL(string: profileSite.text ?? "") else { return }
            let webViewViewModel = WebViewViewModel()
            let webViewController = WebViewViewController(viewModel: webViewViewModel, url: url)
            navigationController?.pushViewController(webViewController, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

// MARK: - ProfileViewControllerDelegate

extension ProfileViewController: ProfileViewControllerDelegate {
    func updateProfile(profile: Profile) {
        viewModel?.changeProfile(profile: profile)
    }
}
