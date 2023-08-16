//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 01.08.2023.
//

import UIKit

final class CatalogViewController: UIViewController, CatalogViewControllerProtocol {
    private var presenter: CatalogViewPresenterProtocol?
    private let sortButton = UIButton()
    private let catalogTable = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CatalogViewPresenter(catalogViewController: self)
        
        view.backgroundColor = .ypWhite
        configureSortButton()
        configureCatalogTable()
        
        makeFetchRequest()
    }
    
    func updateTableView() {
        catalogTable.reloadData()
    }
    
    private func makeFetchRequest() {
        UIBlockingProgressHUD.show()
        presenter?.makeFetchRequest()
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
    
    @objc private func sortButtonTap() {
        let Alert = UIAlertController(title: NSLocalizedString("sorting.name", comment: "Заголовок аллерта сортировки"), message: nil, preferredStyle: .actionSheet)
        
        let sortByNameAction = UIAlertAction(title: NSLocalizedString("catalog.sorting.name", comment: "Алерт сортировки: сортировка по названию"), style: .default) { [weak self] _ in
            UserDefaults.standard.set(2, forKey: "catalog.sort")
            self?.presenter?.updateCatalogData()
            self?.updateTableView()
        }
        let sortByNFTAction = UIAlertAction(title: NSLocalizedString("catalog.sorting.nft", comment: "Алерт сортировки: сортировка по количеству nft"), style: .default) { [weak self] _ in
            UserDefaults.standard.set(1, forKey: "catalog.sort")
            self?.presenter?.updateCatalogData()
            self?.updateTableView()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("sorting.close", comment: "Закрытие алерта сортировки"), style: .cancel)
        
        Alert.addAction(sortByNameAction)
        Alert.addAction(sortByNFTAction)
        Alert.addAction(cancelAction)
        present(Alert, animated: true, completion: nil)
    }
    
    private func configureCatalogTable() {
        if !view.contains(sortButton) { return }
        
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
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.catalogCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.configureCell(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        let collectionScreen = presenter.createCollectionScreen(collectionIndex: indexPath.row)
        present(collectionScreen, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        if indexPath.row + 1 == presenter.catalogCount() {
            makeFetchRequest()
        }
    }
}
