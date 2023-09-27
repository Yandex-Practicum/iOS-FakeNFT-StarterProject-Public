//
//  Developers.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 22.09.2023.
//

import UIKit

final class DevelopersViewController: UIViewController {
    // MARK: - Properties

    private  let viewModel: DevelopersViewModel
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Над проектом работали:"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var devsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DevelopersTableViewCell.self, forCellReuseIdentifier: DevelopersTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    init(viewModel: DevelopersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layouts()
        setupNavBar()
        bind()

    }
    // MARK: - Private Methods

    private func bind() {
        viewModel.myDevsDidChange = { [weak self] in
            self?.devsTableView.reloadData()
        }
    }

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.topItem?.title = ""
    }

    private func layouts() {
        view.addSubview(devsTableView)
        NSLayoutConstraint.activate([
            devsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            devsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            devsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            devsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension DevelopersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.devs.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DevelopersTableViewCell.identifier,
            for: indexPath) as? DevelopersTableViewCell else {
            assertionFailure("Не удалось создать ячейку таблицы DevelopersTableViewCell")
            return UITableViewCell()
        }

        let developer = viewModel.devs[indexPath.row]
        cell.configure(with: developer)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }
}
