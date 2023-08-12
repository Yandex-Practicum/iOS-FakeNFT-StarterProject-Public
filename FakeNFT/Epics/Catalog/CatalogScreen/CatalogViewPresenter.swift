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
                guard let self = self else { return }
                updateTableView()
            }
    }
    
    func configureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatalogViewTableCell.cellReuseIdentifier)
        guard let catalogCell = cell as? CatalogViewTableCell else { return UITableViewCell() }
        catalogCell.selectionStyle = .none
        
        let data = catalogData[indexPath.row]
        
        catalogCell.setImage(link: data.cover)
        catalogCell.setNftCollectionLabel(collectionName: data.name, collectionCount: data.nfts.count)
        
        return catalogCell
    }
    
    func createCollectionScreen(collectionIndex: Int) -> CollectionScreenViewController {
        let collectionScreen = CollectionScreenViewController()
        collectionScreen.modalPresentationStyle = .fullScreen
        collectionScreen.dataModel = catalogData[collectionIndex]
        return collectionScreen
    }
    
    func updateCatalogData() {
        catalogData = catalogNetworkService.collections.sorted(by: { $0.nfts.count > $1.nfts.count })
    }
    
    func catalogCount() -> Int {
        catalogData.count
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
    
    func makeFetchRequest() {
        catalogNetworkService.fetchCollectionNextPage()
    }
}
