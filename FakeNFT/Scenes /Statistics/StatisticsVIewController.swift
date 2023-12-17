//
// Created by Андрей Парамонов on 14.12.2023.
//

import UIKit

final class StatisticsVIewController: UIViewController {
    private let viewModel: StatisticsViewModel

    private lazy var sortButton: UIButton = {
        let sortButton = UIButton()
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.setImage(UIImage(named: "sort"), for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return sortButton
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StatisticsViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        return refreshControl
    }()

    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        setupView()
        viewModel.viewDidLoad()
    }

    private func setupBindings() {
        viewModel.usersObservable.bind { [weak self] _ in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        viewModel.isLoadingObservable.bind { isLoading in
            if isLoading {
                UIBlockingProgressHUD.show()
            } else {
                UIBlockingProgressHUD.dismiss()
            }
        }
        viewModel.isRefreshingObservable.bind { [weak self] isRefreshing in
            if !isRefreshing {
                self?.refreshControl.endRefreshing()
            }
        }
    }

    private func setupView() {
        view.backgroundColor = .background
        addSubviews()
        setupConstraints()
    }

    @objc
    private func sortButtonTapped() {
        let alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("Statistics.Sort.Message", comment: ""),
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Statistics.Sort.ByName", comment: ""),
                                      style: .default,
                                      handler: { [weak self] _ in
                                          self?.viewModel.sortBy(.name)
                                      }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Statistics.Sort.ByRating", comment: ""),
                                      style: .default,
                                      handler: { [weak self] _ in
                                          self?.viewModel.sortBy(.rating)
                                      }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Statistics.Sort.Close", comment: ""),
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }

    private func addSubviews() {
        view.addSubview(sortButton)
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                sortButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 44 + 2),
                sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
                sortButton.widthAnchor.constraint(equalToConstant: 42),
                sortButton.heightAnchor.constraint(equalToConstant: 42),

                tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
    }

    @objc
    private func refreshControlPulled() {
        viewModel.didTriggerRefreshAction()
    }
}

extension StatisticsVIewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StatisticsViewCell = tableView.dequeueReusableCell()
        let cellModel = viewModel.itemModel(for: indexPath)
        cell.configure(with: cellModel)
        return cell
    }
}

extension StatisticsVIewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectModel(at: indexPath)
    }
}
