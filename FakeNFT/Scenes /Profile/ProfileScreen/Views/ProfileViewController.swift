import UIKit
import Kingfisher
import ProgressHUD

final class ProfileViewController: UIViewController {

    // MARK: - UI properties

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline2
        label.numberOfLines = 2
        return label
    }()

    private let userDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.numberOfLines = .zero
        return label
    }()

    private let userWebSiteTextView: UITextView = {
        let textView = UITextView()
        let text = ""
        let attributedString = NSMutableAttributedString(string: text)
        let linkRange = NSRange(location: 0, length: text.count)
        attributedString.addAttribute(.link, value: text, range: linkRange)
        textView.attributedText = attributedString
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.font = .caption1
        textView.textContainer.lineFragmentPadding = 16
        return textView
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "edit"), for: .normal)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        return imageView
    }()

    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileCell.self)
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Properties

    private let viewModel: ProfileViewModelProtocol
    private lazy var router = ProfileRouter(viewController: self)

    // MARK: - Lifecycle

    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc
    private func editButtonTapped() {
        router.routeToEditingViewController()
    }

    // MARK: - Methods

    private func bind() {
        viewModel.observeUserProfileChanges { [weak self] profileModel in
            guard let self = self else { return }

            if profileModel == nil {
                // Показываем индикатор загрузки, если данные еще не загружены
                ProgressHUD.show(NSLocalizedString("ProgressHUD.loading", comment: ""))
            } else {
                // Обновление UI и скрытие индикатора загрузки
                self.updateUI(with: profileModel)
            }
        }
    }

    private func updateUI(with model: UserProfile?) {
        guard let model = model else {
            // Обработка ошибки или отсутствия данных
            ProgressHUD.showError(NSLocalizedString("ProfileViewController.errorLoadingProfile", comment: ""))
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.profileImageView.kf.setImage(with: URL(string: model.avatar))
            self?.userNameLabel.text = model.name
            self?.userDescriptionLabel.text = model.description
            self?.userWebSiteTextView.text = model.website
            self?.tabBarController?.tabBar.isHidden = false
            self?.profileTableView.reloadData()
            [self?.editButton, self?.profileImageView, self?.userNameLabel, self?.userDescriptionLabel, self?.userWebSiteTextView, self?.profileTableView].forEach { $0?.isHidden = false }

            // Скрываем индикатор загрузки
            ProgressHUD.dismiss()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.delegate = self
        self.tabBarController?.tabBar.isHidden = true

        setupViews()
        bind() // Устанавливаем привязку данных

        viewModel.viewDidLoad() // Запускаем процесс загрузки данных
    }

    // MARK: - Layout methods

    private func setupViews() {
        view.backgroundColor = .nftWhite

        [editButton, profileImageView, userNameLabel, userDescriptionLabel, userWebSiteTextView, profileTableView].forEach {
            view.addViewWithNoTAMIC($0)
            $0.isHidden = true
        }

        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            editButton.heightAnchor.constraint(equalToConstant: 42),
            editButton.widthAnchor.constraint(equalTo: editButton.heightAnchor, multiplier: 1.0),

            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),

            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),

            userDescriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            userDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userDescriptionLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor),

            userWebSiteTextView.topAnchor.constraint(equalTo: userDescriptionLabel.bottomAnchor, constant: 8),
            userWebSiteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userWebSiteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            profileTableView.topAnchor.constraint(equalTo: userWebSiteTextView.bottomAnchor, constant: 40),
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.heightAnchor.constraint(equalToConstant: 162)
        ])
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileCell = tableView.dequeueReusableCell()
        var cellTitle = ""
        switch indexPath.row {
        case 0:
            cellTitle = NSLocalizedString("ProfileViewController.myNFT", comment: "") + "(\(viewModel.userProfile?.nfts.count ?? 0))"
        case 1:
            cellTitle = NSLocalizedString("ProfileViewController.favouritesNFT", comment: "") + "(\(viewModel.userProfile?.likes.count ?? 0))"
        case 2:
            cellTitle = NSLocalizedString("ProfileViewController.aboutDeveloper", comment: "")
        default:
            break
        }

        cell.configure(title: cellTitle)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            router.routeToUserNFT(nftList: viewModel.userProfile?.nfts ?? [])
        case 1:
            router.routeToFavoritesNFT(nftList: viewModel.userProfile?.likes ?? [])
        case 2:
            if let url = URL(string: userWebSiteTextView.text) {
                router.routeToWebView(url: url)
            }
        default:
            break
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is ProfileViewController {
            navigationController.setNavigationBarHidden(true, animated: animated)
        } else if viewController is UserNFTViewController || viewController is FavoritesNFTViewController || viewController is WebViewViewController {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }
}
