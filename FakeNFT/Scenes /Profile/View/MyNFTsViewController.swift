//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 23.01.2026.
//

import UIKit

// MARK: - Protocols

protocol MyNFTsViewProtocol: AnyObject {
    func closeScreen()
    func showSortAlert(options: [Sorting])
}

// MARK: - MyNFTsViewController

final class MyNFTsViewController: UIViewController {

    // MARK: - Properties

    private let presenter: MyNFTsPresenterProtocol

    private var myNFTs: [NFTCartModel] = []

    // MARK: - UI

    private lazy var emptyNFTLabel =
    UILabel.emptyStateLabel(text: "У Вас еще нет NFT")

    private lazy var myNFTTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyNFTCell.self, forCellReuseIdentifier: "MyNFTCell")
        tableView.backgroundColor = .whiteApp
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Initializers

    init(presenter: MyNFTsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteApp
        setupNavigationBar()
        addSubviews()
        setupConstraints()
        setupMocks()
        updateUI()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        setupBaseNavigationBar()
        navigationItem.leftBarButtonItem = .backButton(
            target: self,
            action: #selector(tapBackButton)
        )
        navigationItem.rightBarButtonItem = .sortButton(
            target: self,
            action: #selector(tapSortButton)
        )
    }

    private func addSubviews() {
        [emptyNFTLabel, myNFTTableView].forEach {
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        [emptyNFTLabel, myNFTTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            emptyNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            myNFTTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            myNFTTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNFTTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myNFTTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupMocks() {
        myNFTs = NFTMockData.myNFTs()
        myNFTTableView.reloadData()
    }

    private func updateUI() {
        let isEmpty = myNFTs.isEmpty
        emptyNFTLabel.isHidden = !isEmpty
        myNFTTableView.isHidden = isEmpty

        navigationItem.title = isEmpty ? nil : "Мои NFT"
        navigationItem.rightBarButtonItem = isEmpty
            ? nil
            : .sortButton(target: self, action: #selector(tapSortButton))
    }

    // MARK: - Actions

    @objc private func tapBackButton() {
        presenter.didTapBack()
        print("назад на главный экран")
    }

    @objc private func tapSortButton() {
        presenter.didTapSort()
        print("сортировка")
    }
    
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension MyNFTsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myNFTs.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyNFTCell.reuseIdentifier,
            for: indexPath
        ) as? MyNFTCell else {
            return UITableViewCell()
        }

        cell.configure(with: myNFTs[indexPath.row])
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        140
    }
}

// MARK: - MyNFTsViewProtocol

extension MyNFTsViewController: MyNFTsViewProtocol {

    func closeScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    func showSortAlert(options: [Sorting]) {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        for option in options {
            alert.addAction(UIAlertAction(title: option.title, style: .default) { [weak self] _ in
                self?.presenter.didSelectSortOption(option)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        
        present(alert, animated: true)
    }
}
