import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    // MARK: - Properties

    private var viewModel: ProfileViewModel

    private  var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 70 / 2
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private lazy var urlTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(showWebView), for: .touchUpInside)
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(ProfileVCTableViewCell.self, forCellReuseIdentifier: ProfileVCTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    // MARK: - Initialiser

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        bind()
        initialisation()
        layout()
        setupNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProfile()
    }

    // MARK: - Private Methods

    private func setupNavBar() {
        let button = UIBarButtonItem(image: UIImage(named: "square.and.pencil"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(editProfile))
        button.tintColor = .label
        navigationItem.setRightBarButtonItems([button], animated: true)
    }

    private func initialisation() {
        guard let profile = viewModel.profile else { return }
        setupView(with: profile)
    }

    private func bind() {
        viewModel.profileDidChange = { [weak self] in
            guard let profile = self?.viewModel.profile else { return }
            self?.setupView(with: profile)
        }
        viewModel.showErrorAlertDidChange = { [weak self] in
            if let needShow = self?.viewModel.showErrorAlert, needShow {
                self?.showErrorAlert {
                    self?.viewModel.getProfile()
                }
            }
        }
    }

    private func setupView(with profile: Profile) {
        profileImageView.kf.setImage(with: profile.avatar)
        nameLabel.text = profile.name
        urlTextButton.setTitle(profile.website.absoluteString, for: .normal)
        descriptionLabel.text = profile.description
        tableView.reloadData()
    }

    private func layout() {
        [tableView, nameLabel, descriptionLabel, urlTextButton, profileImageView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),

            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),

            urlTextButton.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            urlTextButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            urlTextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: urlTextButton.bottomAnchor, constant: 44),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func showErrorAlert(action: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Ошибка загрузки данных",
            preferredStyle: .alert
        )

        let alertAction = UIAlertAction(
            title: "Ок",
            style: .default
        )
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }

    @objc private func showWebView() {
        guard let url = viewModel.profile?.website else { return }
        let webView = WebView(url: url)
        present(webView, animated: true)
    }

    @objc private func editProfile() {
        guard let viewController = viewModel.getEditProfileViewController() else { return }
        let editVC = UINavigationController(rootViewController: viewController)
        present(editVC, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            guard let myNftVC = viewModel.getMyNftViewController() else { return }
            navigationController?.pushViewController(myNftVC, animated: true)
        case 1:
            guard let favoritesNftVC = viewModel.getMyFavouritesNftViewController() else { return }
            navigationController?.pushViewController(favoritesNftVC, animated: true)
        case 2:
            let viewModel = DevelopersViewModel()
            let developerVC = DevelopersViewController(viewModel: viewModel)
            navigationController?.pushViewController(developerVC, animated: true)
        default:
            return
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileVCTableViewCell.identifier,
            for: indexPath) as? ProfileVCTableViewCell else {
            assertionFailure("Не удалось создать ячейку таблыцы ProfileVCTableViewCell")
            return UITableViewCell()
        }
        let title = viewModel.fetchViewTitleForCell(with: indexPath)
        cell.configureCell(text: title)
        return cell
    }

}
