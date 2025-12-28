import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        let navItem = UINavigationItem(title: "")
        navItem.rightBarButtonItem = sortButton
        
        navBar.items = [navItem]
        return navBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StatisticTableViewCell.self)
        return tableView
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(resource: .sortButton),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        button.tintColor = .black
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Properties
    private let presenter: StatisticPresenterProtocol
    
    // MARK: - Initializer
    init(presenter: StatisticPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func sortButtonTapped() {
        let currentSort = presenter.currentSortType
        showSortOptions(currentSort: currentSort)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension StatisticViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StatisticTableViewCell = tableView.dequeueReusableCell()
        let user = presenter.user(at: indexPath.row)
        let place = presenter.getPlace(for: indexPath.row)
        cell.configure(with: user, place: place)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectUser(at: indexPath.row)
    }
}

// MARK: - StatisticViewProtocol
extension StatisticViewController: StatisticViewProtocol {
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(message: String, retryAction: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "Повторить",
            style: .default
        ) { _ in
            retryAction()
        })
        
        alert.addAction(UIAlertAction(
            title: "Отмена",
            style: .cancel
        ))
        
        present(alert, animated: true)
    }
    
    func showSortOptions(currentSort: StatisticPresenter.SortType) {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for sortType in StatisticPresenter.SortType.allCases {
            let title = sortType == currentSort ? "✓ \(sortType.displayName)" : sortType.displayName
            
            alert.addAction(UIAlertAction(
                title: title,
                style: .default
            ) { [weak self] _ in
                self?.presenter.didSelectSortOption(sortType)
            })
        }
        
        alert.addAction(UIAlertAction(
            title: "Отмена",
            style: .cancel
        ))
        
        present(alert, animated: true)
    }
}
