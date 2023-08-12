//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 01.08.2023.
//

import UIKit

final class CatalogViewController: UIViewController {
    private let sortButton = UIButton() // возможно в презентер
    private let table = UITableView() // возможно в презентер
    
    private var catalogData: [CatalogDataModel] = []
    private var catalogNetworkServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catalogNetworkServiceObserver = NotificationCenter.default
            .addObserver(
                forName: CatalogNetworkService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        
        view.backgroundColor = .ypWhite // возможно в презентер
        configureButton() // возможно в презентер
        configureTable() // возможно в презентер
        
        UIBlockingProgressHUD.show()
        CatalogNetworkService.shared.fetchCollectionNextPage()
    }
    
    private func updateTableViewAnimated() {
        let catalogNetworkService = CatalogNetworkService.shared
        let oldCount = catalogData.count
        let newCount = catalogNetworkService.collections.count
        catalogData = catalogNetworkService.collections.sorted(by: { $0.nfts.count > $1.nfts.count })
        if oldCount != newCount {
            table.reloadData()
        }
        UIBlockingProgressHUD.dismiss()
    }
    
    private func configureButton() { // возможно в презентер
        sortButton.setImage(UIImage.sortButton?.withTintColor(.ypBlack), for: .normal)
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortButton)
        NSLayoutConstraint.activate([
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func configureTable() { // возможно в презентер
        if !view.contains(sortButton) { return }
        
        table.backgroundColor = .clear
        table.separatorStyle = .none
        
        table.register(CatalogViewTableCell.self, forCellReuseIdentifier: CatalogViewTableCell.cellReuseIdentifier)
        table.dataSource = self
        table.delegate = self
        
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            table.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        catalogData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CatalogViewTableCell.cellReuseIdentifier)
        guard let catalogCell = cell as? CatalogViewTableCell else { return UITableViewCell() }
        catalogCell.selectionStyle = .none
        
        let data = catalogData[indexPath.row]
        
        //временно
        catalogCell.setImage(link: data.cover)
        catalogCell.setNftCollectionLabel(collectionName: data.name, collectionCount: data.nfts.count)
        
        return catalogCell
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionScreen = CollectionScreenViewController()
        collectionScreen.modalPresentationStyle = .fullScreen
        collectionScreen.dataModel = catalogData[indexPath.row]
        present(collectionScreen, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1 == catalogData.count) {
            UIBlockingProgressHUD.show()
            CatalogNetworkService.shared.fetchCollectionNextPage()
        }
    }
}
