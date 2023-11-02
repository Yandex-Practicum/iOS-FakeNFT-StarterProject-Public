import UIKit
import Kingfisher

final class StatisticsUserProfileViewController: UIViewController {
    private let usersAvatar: UIImageView = {
        let usersAvatar = UIImageView()
        usersAvatar.layer.cornerRadius = 35
        usersAvatar.layer.masksToBounds = true
        usersAvatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        usersAvatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return usersAvatar
    }()

    private let userName: UILabel = {
        let userName = UILabel()
        userName.font = .headline3
        return userName
    }()

    private let userDescription: UILabel = {
        let userDescription = UILabel()
        userDescription.font = .caption2
        userDescription.numberOfLines = 0
        return userDescription
    }()

    private let usersWebsite: UIButton = {
        let usersWebsite = UIButton()
        usersWebsite.layer.cornerRadius = 16
        usersWebsite.layer.borderWidth = 1
        usersWebsite.setTitle("goWebsite", for: .normal)
        usersWebsite.layer.borderColor = UIColor.ypBlack?.cgColor
        usersWebsite.titleLabel?.font = .caption1
        usersWebsite.setTitleColor(.ypBlack, for: .normal)

        return usersWebsite
    }()

    private let usersCollectionButton: UIButton = {
        let usersCollectionButton = UIButton()
        usersCollectionButton.setTitleColor(.ypBlack, for: .normal)
        usersCollectionButton.titleLabel?.font = .bodyBold
        let chevron = UIImage(systemName: "chevron.forward")?
            .withTintColor(.textPrimary)
            .withRenderingMode(.alwaysOriginal)
        let chevronImageView = UIImageView(image: chevron)
        usersCollectionButton.addSubview(chevronImageView)
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            usersCollectionButton.titleLabel!.leadingAnchor.constraint(equalTo: usersCollectionButton.leadingAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: usersCollectionButton.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: usersCollectionButton.trailingAnchor)
        ])
        return usersCollectionButton
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private let viewModel: StatisticsUserProfileViewModel

    init(viewModel: StatisticsUserProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        viewModel.$profile.bind(executeInitially: true) { [weak self] profile in
            guard let self, let profile else {
                return
            }

            self.usersAvatar.kf.setImage(with: profile.avatar)
            self.userName.text = profile.name
            self.userDescription.text = profile.description
            self.usersCollectionButton.setTitle("nftCollection"   + " (\(profile.nfts.count))", for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        usersAvatar.kf.cancelDownloadTask()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background

        usersCollectionButton.addTarget(self, action: #selector(usersCollectionButtonTapped), for: .touchUpInside)
        usersWebsite.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)

        setupConstraints()
        configureNavigationBar()

        viewModel.loadData()
    }

    func setLoaderIsHidden(_ isHidden: Bool) {
        isHidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }

    private func setupConstraints() {
        view.addSubview(activityIndicator)
        activityIndicator.layer.zPosition = 9999
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        let hStackAvatarAndName = UIStackView(arrangedSubviews: [usersAvatar, userName])
        hStackAvatarAndName.translatesAutoresizingMaskIntoConstraints = false
        hStackAvatarAndName.axis = .horizontal
        hStackAvatarAndName.spacing = 16

        let vStack = UIStackView(arrangedSubviews: [
            hStackAvatarAndName,
            VSpacer(height: 20),
            userDescription,
            VSpacer(height: 28),
            usersWebsite,
            VSpacer(height: 40),
            usersCollectionButton
        ])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.backgroundColor = .background
        view.addSubview(vStack)

        let constraints = [
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            usersWebsite.heightAnchor.constraint(equalToConstant: 40),
            usersAvatar.heightAnchor.constraint(equalToConstant: 70),
            usersAvatar.widthAnchor.constraint(equalToConstant: 70),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]

        constraints.forEach {
            $0.priority = .defaultHigh
        }

        NSLayoutConstraint.activate(constraints)
    }

    private func configureNavigationBar() {
        let backImage = UIImage(systemName: "chevron.backward")?
            .withTintColor(.ypBlack ?? .black)
            .withRenderingMode(.alwaysOriginal)

        if self !== navigationController?.viewControllers.first {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: backImage,
                style: .plain,
                target: self,
                action: #selector(backButtonTapped)
            )
        }
    }

    // MARK: - Actions

    @objc
    private func usersCollectionButtonTapped() {
        viewModel.didTapNFTsCollection()
    }

    @objc
    private func websiteButtonTapped() {
        viewModel.didTapWebsite()
    }

    @objc
    private func backButtonTapped() {
        viewModel.didTapBack()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        usersWebsite.layer.borderColor = UIColor.ypBlack?.cgColor
    }
}
