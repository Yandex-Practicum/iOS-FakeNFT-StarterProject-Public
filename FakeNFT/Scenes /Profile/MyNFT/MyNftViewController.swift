//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 04.09.2023.
//

import UIKit

final class MyNftViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: MyNftViewModel

    private lazy var myNftTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyNftTableViewCell.self, forCellReuseIdentifier: MyNftTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои NFT"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialiser
    init(viewModel: MyNftViewModel) {
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
        viewModel.myNftsDidChange = { [weak self] in
            self?.myNftTableView.reloadData()
        }
        viewModel.likesDidChange = { [weak self] in
            self?.myNftTableView.reloadData()
        }
        viewModel.showErrorAlertDidChange = { [weak self] in
            if let needShow = self?.viewModel.showErrorAlert, needShow {
                self?.showErrorAlert(action: {
                    self?.viewModel.initialisation()
                })
            }
        }
    }

    private func layouts() {
        view.addSubview(myNftTableView)
        NSLayoutConstraint.activate([
            myNftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            myNftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myNftTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.topItem?.title = ""
        let sortButton = UIBarButtonItem(image: UIImage(named: "Vector"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(sortNft))
        navigationItem.setRightBarButton(sortButton, animated: true)
    }

    @objc private func sortNft() {
        showAlert()
    }

    private func showErrorAlert(action: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Ошибка загрузки данных",
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: "Ок", style: .default) { _ in action() }
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }

    private func showAlert() {
        let alertController = UIAlertController(title: nil,
                                                message: "Сортировка",
                                                preferredStyle: .actionSheet)

        let actionFirst = UIAlertAction(
            title: "По цене",
            style: .default
        ) { [weak self] (_) in
            guard let self = self else { return }
            self.viewModel.sort(by: .price)
        }
        alertController.addAction(actionFirst)
        actionFirst.accessibilityIdentifier = AccessibilityIdentifiers.priceSorting

        let actionSecond = UIAlertAction(
            title: "По рейтингу",
            style: .default
        ) { [weak self] (_) in
            guard let self = self else { return }
            self.viewModel.sort(by: .rating)
        }
        alertController.addAction(actionSecond)
        actionSecond.accessibilityIdentifier = AccessibilityIdentifiers.ratingSorting

        let actionThird = UIAlertAction(
            title: "По имени", style: .default
        ) { [weak self] (_) in
            guard let self = self else { return }
            self.viewModel.sort(by: .name)
        }
        alertController.addAction(actionThird)
        actionThird.accessibilityIdentifier = AccessibilityIdentifiers.nameSorting

        let actionCancel = UIAlertAction(
            title: "Закрыть", style: .cancel
        )
        alertController.addAction(actionCancel)
        navigationController?.present(alertController, animated: true)
    }
}

extension MyNftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension MyNftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myNft.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyNftTableViewCell.identifier,
            for: indexPath
        ) as? MyNftTableViewCell else {
            assertionFailure("Не удалось создать ячейку таблицы MyNftViewController")
            return UITableViewCell()
        }
        let myNft = viewModel.myNft[indexPath.row]
        let isLike = viewModel.likes.contains(myNft.id)

        cell.configureMyNftCell(with: myNft, isLiked: isLike)
        cell.likeButtonAction = {[weak self] in
            self?.viewModel.likeButtonTapped(indexPath: indexPath)
        }
        return cell
    }
}
