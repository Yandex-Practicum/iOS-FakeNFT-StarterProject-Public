import UIKit

private enum CatalogLayout {
    static let tableViewLeading: CGFloat = 16
    static let tableViewTrailing: CGFloat = -16
}

final class CatalogViewController: UIViewController {
    // MARK: - UI
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - MVP Dependencies
    private let output: CatalogViewOutput
    
    // MARK: - Data
    private var items: [Catalog] = []
    
    // MARK: - Init
    init(output: CatalogViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.viewDidLoad()
    }
}

    // MARK: - Setup UI
    private extension CatalogViewController {
    func setupUI() {
        view.backgroundColor = .whiteUniversal
        
        setupTableView()
        setupActivityIndicator()
        setupNavigationItems()
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.reuseIdentifier)
        
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: CatalogLayout.tableViewLeading),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: CatalogLayout.tableViewTrailing),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupNavigationItems() {
        let sortImage = UIImage(resource: .sort)
        let sortButton = UIBarButtonItem(
            image: sortImage,
            style: .plain,
            target: self,
            action: #selector(showSortOptions)
        )
        
        navigationItem.rightBarButtonItem = sortButton
        
        sortButton.tintColor = .blackUniversal
    }
    
    @objc
    func showSortOptions() {
        
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let sortByNameAction = UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            self?.output.didTapSortByName()
        }
        
        let sortByCountAction = UIAlertAction(title: "По количеству NFT", style: .default) { [weak self] _ in
            self?.output.didTapSortByCount()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(sortByNameAction)
        alert.addAction(sortByCountAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

    // MARK: - UITableViewDataSource
    extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogCell.reuseIdentifier,
            for: indexPath
        ) as? CatalogCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.configure(imageURLString: item.cover, text: item.name, numberOfNfts: item.nfts.count)
        
        return cell
    }
}

    // MARK: - UITableViewDelegate
    extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        output.didSelectItem(at: indexPath.row)
    }
}

    // MARK: - CatalogViewInput
    extension CatalogViewController: CatalogViewInput {
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    func showCatalog(_ items: [Catalog]) {
        self.items = items
        tableView.reloadData()
    }
}






