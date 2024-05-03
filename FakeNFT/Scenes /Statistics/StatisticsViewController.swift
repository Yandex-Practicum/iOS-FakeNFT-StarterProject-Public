import UIKit

// MARK: - Protocol
protocol StatisticsViewProtocol: AnyObject, ErrorView, LoadingView, SortingView {
    func displayCells(_ cellModels: [UserCellModel])
}

final class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: StatisticsPresenterProtocol
    private var cellModels = [UserCellModel]()
    
    internal lazy var activityIndicator = UIActivityIndicatorView()
    
    private lazy var sortingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "sort") ?? UIImage(), for: .normal)
        button.tintColor = UIColor.segmentActive
        button.addTarget(self, action: #selector(didTapSortingButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var statisticsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StatisticsTableCell.self)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Init

    init(presenter: StatisticsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter.viewDidLoad()
    }
    
    @IBAction private func didTapSortingButton() {
        presenter.showSortingMenu()
    }
    
    private func setupViews() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(statisticsTableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortingButton)

        statisticsTableView.addSubview(activityIndicator)
        statisticsTableView.dataSource = self
        statisticsTableView.delegate = self
    }
    
    private func setupConstraints() {
        activityIndicator.constraintCenters(to: statisticsTableView)
        NSLayoutConstraint.activate([
            statisticsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            statisticsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statisticsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - StatisticsView Protocol

extension StatisticsViewController: StatisticsViewProtocol {
    func displayCells(_ cellModels: [UserCellModel]) {
        self.cellModels = cellModels
        statisticsTableView.reloadData()
    }
}

// MARK: - TableView Protocols

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StatisticsTableCell = statisticsTableView.dequeueReusableCell()
        let cellModel = cellModels[indexPath.row]
        cell.configure(with: cellModel)
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
