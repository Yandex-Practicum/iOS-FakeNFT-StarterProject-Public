//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 01.08.2023.
//

import UIKit

final class CatalogViewController: UIViewController, CatalogViewControllerProtocol {
    private var presenter: CatalogViewPresenterProtocol
    private var alertPresenter: AlertPresenterProtocol
    private let sortButton = UIButton()
    private let catalogTable = UITableView()
    
    init(presenter: CatalogViewPresenterProtocol, alertPresenter: AlertPresenterProtocol) {
        self.presenter = presenter
        self.alertPresenter = alertPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        configureSortButton()
        configureCatalogTable()
        
        makeFetchRequest()
    }
    
    func updateTableView() {
        catalogTable.reloadData()
    }
    
    func removeHud() {
        UIBlockingProgressHUD.dismiss()
    }
    
    private func configureSortButton() {
        sortButton.setImage(UIImage.sortButton?.withTintColor(.ypBlack), for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTap), for: .touchUpInside)
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortButton)
        NSLayoutConstraint.activate([
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func configureCatalogTable() {
        guard view.contains(sortButton) else { return }
        
        catalogTable.backgroundColor = .clear
        catalogTable.separatorStyle = .none
        
        catalogTable.register(CatalogViewTableCell.self)
        catalogTable.dataSource = self
        catalogTable.delegate = self
        
        catalogTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(catalogTable)
        NSLayoutConstraint.activate([
            catalogTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            catalogTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            catalogTable.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            catalogTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureCell(cell: CatalogViewTableCell, index: Int) {
        let data = presenter.viewDidRequestDataByIndex(index: index)
        cell.selectionStyle = .none
        cell.setImage(link: data.cover)
        cell.setNftCollectionLabel(collectionName: data.name, collectionCount: data.nfts.count)
    }
    
    private func makeFetchRequest() {
        UIBlockingProgressHUD.show()
        presenter.viewMadeFetchRequest()
    }
    
    @objc private func sortButtonTap() {
        alertPresenter.show(models: presenter.alertActions)
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.catalogCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let catalogCell: CatalogViewTableCell = tableView.dequeueReusableCell()
        configureCell(cell: catalogCell, index: indexPath.row)
        return catalogCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionScreen = presenter.viewDidRequestCollectionScreen(collectionIndex: indexPath.row)
        present(collectionScreen, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter.catalogCount {
            makeFetchRequest()
        }
    }
}
