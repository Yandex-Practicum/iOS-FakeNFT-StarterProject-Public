//
//  CatalogViewPresenter.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import UIKit

final class CatalogViewPresenter: CatalogViewPresenterProtocol {
    private weak var catalogViewController: CatalogViewControllerProtocol?
    private var catalogData: [CatalogDataModel] = []
    private var catalogNetworkService = CatalogNetworkService.shared
    private var catalogNetworkServiceObserver: NSObjectProtocol?
    
    init(catalogViewController: CatalogViewControllerProtocol) {
        self.catalogViewController = catalogViewController
        catalogNetworkServiceObserver = NotificationCenter.default
            .addObserver(
                forName: CatalogNetworkService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateTableView()
            }
    }
    
    func configureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let catalogCell: CatalogViewTableCell = tableView.dequeueReusableCell()
        catalogCell.selectionStyle = .none
        
        let data = catalogData[indexPath.row]
        
        catalogCell.setImage(link: data.cover)
        catalogCell.setNftCollectionLabel(collectionName: data.name, collectionCount: data.nfts.count)
        
        return catalogCell
    }
    
    func createCollectionScreen(collectionIndex: Int) -> CollectionScreenViewController {
        let collectionScreenController = CollectionScreenViewController()
        collectionScreenController.modalPresentationStyle = .fullScreen
        let collectionScreenPresenter = CollectionScreenViewPresenter(catalogDataModel: catalogData[collectionIndex])
        collectionScreenController.presenter = collectionScreenPresenter
        collectionScreenPresenter.collectionScreenViewController = collectionScreenController
        return collectionScreenController
    }
    
    func updateCatalogData() {
        catalogData = catalogNetworkService.collections.sorted(by: { $0.nfts.count > $1.nfts.count })
    }
    
    func catalogCount() -> Int {
        catalogData.count
    }
    
    func makeFetchRequest() {
        catalogNetworkService.fetchCollectionNextPage()
    }
    
    private func updateTableView() {
        let oldCount = catalogCount()
        let newCount = catalogNetworkService.collections.count
        updateCatalogData()
        if oldCount != newCount {
            catalogViewController?.updateTableView()
        }
        catalogViewController?.removeHud()
    }
}
