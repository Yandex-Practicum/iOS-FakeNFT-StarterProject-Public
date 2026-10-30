import UIKit
import ProgressHUD // Используем библиотеку для лоадера, которая уже есть в скелете

final class ProfileViewController: UIViewController, ProfileViewProtocol {
    
    // MARK: - Presenter
    private let presenter: ProfilePresenterProtocol
    
    // MARK: - UI Элементы
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileMenuCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var headerView = ProfileHeaderView()
    
    // Меню
    private let menuItems = ["Мои NFT", "Избранные NFT"]
    
    // MARK: - Init
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        
        presenter.viewDidLoad()
    }
    
    // Настройка правой кнопки (карандаш)
    private func setupNavigationBar() {
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "pencil"),
            style: .plain,
            target: self,
            action: #selector(didTapEditButton)
        )
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc private func didTapEditButton() {
        presenter.didTapEdit()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateHeaderLayout() {
        // Важно для UITableView: нужно правильно рассчитать размер шапки
        guard let header = tableView.tableHeaderView else { return }
        
        let size = header.systemLayoutSizeFitting(
            CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        if header.frame.height != size.height {
            header.frame.size.height = size.height
            tableView.tableHeaderView = header
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderLayout()
    }
    
    // MARK: - ProfileViewProtocol
    
    func showLoading() {
        DispatchQueue.main.async {
            ProgressHUD.show()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
    }
    
    func showProfile(_ profile: Profile) {
        DispatchQueue.main.async {
            self.headerView.configure(with: profile)
            self.updateHeaderLayout() // Пересчитываем высоту шапки
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // Открытие экрана редактирования
    func showEditScreen(with profile: Profile) {
        let editVC = EditProfileViewController(profile: profile)
        
        editVC.onProfileUpdated = { [weak self] updatedProfile in
                    self?.presenter.updateProfile(with: updatedProfile)
                }
        
        let navController = UINavigationController(rootViewController: editVC)
        present(navController, animated: true)
    }
    
    func navigateToMyNFTs() {
        let myNFTVC = MyNFTViewController()
        navigationController?.pushViewController(myNFTVC, animated: true)
    }
    
    func navigateToFavorites() {
        let favoritesVC = FavoriteNFTViewController()
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = menuItems[indexPath.row]
        content.textProperties.font = .systemFont(ofSize: 17, weight: .bold)
        cell.contentConfiguration = content
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            presenter.didTapMyNFTs()
        } else {
            presenter.didTapFavorites()
        }
    }
}
