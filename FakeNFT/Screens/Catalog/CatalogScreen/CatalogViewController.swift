//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Денис Николаев on 16.07.2024.
//

import UIKit
import Kingfisher
import SnapKit
import ProgressHUD

// MARK: - Protocol

protocol CatalogViewControllerProtocol: AnyObject {
    func reloadTableView()
}

final class CatalogViewController: UIViewController, CatalogViewControllerProtocol {
    private var presenter: CatalogPresenterProtocol
    private let cartService: CartControllerProtocol
    private let modulesAssembly = ModulesAssembly.shared

    private lazy var collectionsRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadNFTCollections), for: .valueChanged)
        return refreshControl
    }()

    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: Asset.Images.sort,
            style: .plain,
            target: self,
            action: #selector(showSortingMenu))
        return button
    }()

    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(CatalogCell.self)
        tableView.refreshControl = collectionsRefreshControl
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    init(presenter: CatalogPresenterProtocol, cartService: CartControllerProtocol) {
        self.presenter = presenter
        self.cartService = cartService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setup()
        presenter.viewController = self
        loadNFTCollections()
        view.backgroundColor = .systemBackground
    }

    private func setupNavigationBar() {
        sortButton.tintColor = .black
        navigationController?.navigationBar.tintColor = .gray
        navigationItem.rightBarButtonItem = sortButton
    }

    private func setup() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.bottom.equalTo(view.snp.bottom)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }
    }

    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.collectionsRefreshControl.endRefreshing()
        }
    }

    @objc func showSortingMenu() {
        let alertMenu = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        alertMenu.addAction(UIAlertAction(title: "По названию", style: .default, handler: { [weak self] (_) in
            self?.presenter.sortNFTS(by: .name)
            self?.reloadTableView()
        }))
        alertMenu.addAction(UIAlertAction(title: "По количеству NFT", style: .default, handler: { [weak self] (_) in
            self?.presenter.sortNFTS(by: .nftCount)
            self?.reloadTableView()
        }))
        alertMenu.addAction(UIAlertAction(title: "Закрыть", style: .cancel))

        present(alertMenu, animated: true)
    }

    @objc func loadNFTCollections() {
        ProgressHUD.show()
        presenter.fetchCollections { [weak self] _ in
            self?.reloadTableView()
        }
    }}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getDataSource().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CatalogCell = tableView.dequeueReusableCell()
        let nftModel = presenter.getDataSource()[indexPath.row]
        let url = URL(string: nftModel.cover.urlDecoder)
        cell.selectionStyle = .none
        cell.setCellImage(with: url)
        cell.setNameLabel(with: "\(nftModel.name) (\(nftModel.nfts.count))")
        ProgressHUD.dismiss()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProgressHUD.show()
        let nftModel = presenter.getDataSource()[indexPath.row]
        let view = modulesAssembly.сatalogСollection(nftModel: nftModel)
        ProgressHUD.dismiss()
        navigationController?.pushViewController(view, animated: true)
    }
}
