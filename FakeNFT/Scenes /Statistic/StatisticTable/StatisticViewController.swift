import UIKit

//MARK: - StatisticViewController
final class StatisticViewController: UIViewController {
    
//    private var mockData = MockData.shared
    let servicesAssembly: ServicesAssembly
    private var statisticFabric: StatisticFabric?
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(resource: .ypWhite)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let sortButton = UIBarButtonItem(title: "",
                                         style: .plain,
                                         target: self,
                                         action: #selector(sortButtonAction))
        sortButton.image = UIImage(resource: .sort).withTintColor(UIColor(resource: .ypBlack), renderingMode: .alwaysOriginal)
        return sortButton
    }()

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
        statisticFabric = StatisticFabric(delegate: self, servicesAssembly: servicesAssembly)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        activateUI()
    }
    
    @objc
    private func sortButtonAction() {
        
        let actionSheet: UIAlertController = {
            let alert = UIAlertController()
            alert.title = NSLocalizedString("Alert.sort", comment: "")
            return alert
        }()
        let sortByName = UIAlertAction(title: NSLocalizedString("Alert.sort.byName", comment: ""),
                                       style: .default) { [weak self] _ in
            self?.statisticFabric?.sortLeaderboardByName()
        }
        let sortByRating = UIAlertAction(title: NSLocalizedString("Alert.sort.byRating", comment: ""),
                                         style: .default) { [weak self] _ in
            self?.statisticFabric?.sortLeaderboardByRating()
        }
        let actionCancel = UIAlertAction(title: NSLocalizedString("Close", comment: ""),
                                         style: .cancel)
        [sortByName, sortByRating, actionCancel].forEach {
            actionSheet.addAction($0)
        }
        present(actionSheet, animated: true)
    }
}

//MARK: - NavigationController
extension StatisticViewController {
    
    func setupNavigation() {
        
        navigationController?.view.backgroundColor = UIColor(resource: .ypWhite)
        navigationItem.rightBarButtonItem = sortButton
    }
}

//MARK: - Show Error
extension StatisticViewController {
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }

        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.reloadFabric()
            self?.tableView.reloadData()
        }
    }
    
    private func reloadFabric() {
        statisticFabric = StatisticFabric(delegate: self, servicesAssembly: servicesAssembly)
    }
}

// MARK: - Add UI-Elements on View
extension StatisticViewController {
    
    func activateUI() {
        
        setTableViewParams()
        setUpdateTable()
        activateConstraints()
    }
    
    func setTableViewParams() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: StatisticTableViewCell.reusedIdentifier)
        tableView.reloadData()
    }
    
    func activateConstraints() {
        
        [tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            //MARK: tableView
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    func setUpdateTable() {
        statisticFabric?.onNeedUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statisticFabric?.getCountOfLeaderboard() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticTableViewCell.reusedIdentifier,
            for: indexPath) as? StatisticTableViewCell,
            let statisticFabric = statisticFabric
        else { return UITableViewCell() }
        
        cell.loadData(
            with: statisticFabric.getUserFromLeaderboard(by: indexPath.row),
            position: indexPath.row + 1)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension StatisticViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let cell = tableView.cellForRow(at: indexPath) as? StatisticTableViewCell else { return }
        
        let vc = UserCardViewController(user: cell.getUser(), servicesAssembly: servicesAssembly)
        let viewToPresent = UINavigationController(rootViewController: vc)
        viewToPresent.modalPresentationStyle = .overFullScreen
        self.present(viewToPresent, animated: true)
    }
}

//MARK: - StatisticFabricDelegate
extension StatisticViewController: StatisticFabricDelegate, ErrorView {
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(with error: Error) {
        self.showError(makeErrorModel(error))
    }
}
