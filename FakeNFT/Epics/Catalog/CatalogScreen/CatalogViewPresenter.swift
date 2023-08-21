//
//  CatalogViewPresenter.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import Foundation

final class CatalogViewPresenter: CatalogViewPresenterProtocol {
    var catalogCount: Int {
        catalogData.count
    }
    var alertActions: [AlertActionModel] {
        let sortByNameAction = AlertActionModel(buttonText: NSLocalizedString("catalog.sorting.name", comment: "Алерт сортировки: сортировка по названию"), style: .default) { [weak self] in
            guard self?.sortState != 2 else { return }
            UserDefaults.standard.set(2, forKey: "catalog.sort")
            self?.updateCatalogData()
            self?.viewController?.updateTableView()
        }
        let sortByNFTAction = AlertActionModel(buttonText: NSLocalizedString("catalog.sorting.nft", comment: "Алерт сортировки: сортировка по количеству nft"), style: .default) { [weak self] in
            guard self?.sortState != 1 else { return }
            UserDefaults.standard.set(1, forKey: "catalog.sort")
            self?.updateCatalogData()
            self?.viewController?.updateTableView()
        }
        return [sortByNameAction, sortByNFTAction]
    }
    
    private weak var viewController: CatalogViewControllerProtocol?
    private var catalogData: [CatalogDataModel] = []
    private var catalogNetworkService = CatalogNetworkService.shared
    private var catalogNetworkServiceObserver: NSObjectProtocol?
    private var sortState: Int {
        UserDefaults.standard.integer(forKey: "catalog.sort")
    }
    
    init() {
        catalogNetworkServiceObserver = NotificationCenter.default
            .addObserver(
                forName: CatalogNetworkService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateTableView()
            }
    }
    
    func viewControllerInitialized(viewController: CatalogViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        guard catalogNetworkService.isPaginationDoesntEnd else { return }
        viewController?.showHud()
        catalogNetworkService.fetchCollectionNextPage()
    }
    
    func didTapCell(at index: Int) {
        let presenter = CollectionScreenViewPresenter(catalogDataModel: catalogData[index])
        let collectionScreenController = CollectionScreenViewController(presenter: presenter)
        presenter.viewControllerInitialized(viewController: collectionScreenController)
        collectionScreenController.modalPresentationStyle = .fullScreen
        viewController?.show(collectionScreenController)
    }
    
    func viewStartedCellConfiguration(at index: Int) -> CatalogDataModel {
        catalogData[index]
    }
    
    func viewWillSetImage(with link: String) -> URL? {
        URL(string: link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
    }
    
    func tableWillEnd(currentIndex: Int) {
        if currentIndex + 1 == catalogCount {
            viewDidLoad()
        }
    }
    
    private func updateTableView() {
        let oldCount = catalogCount
        let newCount = catalogNetworkService.collections.count
        updateCatalogData()
        if oldCount != newCount {
            viewController?.updateTableView()
        }
        viewController?.removeHud()
    }
    
    private func updateCatalogData() {
        switch sortState {
        case 1:
            catalogData = catalogNetworkService.collections.sorted(by: { $0.nfts.count > $1.nfts.count })
        case 2:
            catalogData = catalogNetworkService.collections.sorted(by: { $0.name < $1.name })
        default:
            catalogData = catalogNetworkService.collections.sorted(by: { $0.nfts.count > $1.nfts.count })
        }
    }
}
