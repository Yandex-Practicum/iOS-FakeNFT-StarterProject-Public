import UIKit

final class StatisticsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let sortButton: UIButton = {
        let sortButton = UIButton()
        sortButton.setImage(UIImage(named: "sortButton"), for: .normal)
        return sortButton
    }()

    private let tableView = UITableView(frame: .zero)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let viewModel: StatisticsViewModel

    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.$userModels.bind(executeInitially: true) { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.$isLoading.bind(executeInitially: true) { [weak self] isLoading in
            self?.setLoaderIsHidden(!isLoading)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        tableView.register(StatisticsTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        sortButton.addTarget(self, action: #selector(statisticsFilter), for: .touchUpInside)

        setupConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)

        viewModel.loadData()
    }

    // MARK: - StatisticsView

    func setLoaderIsHidden(_ isHidden: Bool) {
        isHidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }

    private func setupConstraints() {
        view.addSubview(activityIndicator)
        activityIndicator.layer.zPosition = 9999
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        sortButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.widthAnchor.constraint(equalToConstant: 42),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc
    private func statisticsFilter() {
        let alert = UIAlertController(
            title: nil,
            message: "Сортировка",
            preferredStyle: .actionSheet
        )

        let nameAction = UIAlertAction(
            title: "По имени",
            style: .default
        ) { [weak self] _ in
            self?.viewModel.didSelectSort(.name)
            alert.dismiss(animated: true)
        }

        let ratingAction = UIAlertAction(
            title: "По рейтингу",
            style: .default
        ) { [weak self] _ in
            self?.viewModel.didSelectSort(.rating)
            alert.dismiss(animated: true)
        }

        let closeAction = UIAlertAction(
            title: "Закрыть",
            style: .cancel) { _ in
                alert.dismiss(animated: true)
            }

        [nameAction, ratingAction, closeAction].forEach {
            alert.addAction($0)
        }

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension StatisticsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.userModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StatisticsTableViewCell = tableView.dequeueReusableCell()
        let model = StatisticsTableViewCellModel(
            userModel: viewModel.userModels[indexPath.row]
        )
        cell.configureWith(model: model)
        return cell
    }
}

extension StatisticsViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(indexPath: indexPath)
    }
}
