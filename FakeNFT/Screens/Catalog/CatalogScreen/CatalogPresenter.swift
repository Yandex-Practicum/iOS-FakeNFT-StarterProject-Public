//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Денис Николаев on 16.07.2024.
//

import Foundation

// MARK: - Protocol

protocol CatalogPresenterProtocol: AnyObject {
    var viewController: CatalogViewControllerProtocol? { get set }
    func fetchCollections(completion: @escaping ([NFTCollection]) -> Void)
    func sortNFTS(by: NFTCollectionsSort)
    func getDataSource() -> [NFTCollection]
}

// MARK: - Final Class

final class CatalogPresenter: CatalogPresenterProtocol {

    weak var viewController: CatalogViewControllerProtocol?
    private var dataProvider: CatalogDataProviderProtocol

    private var dataSource: [NFTCollection] {
        dataProvider.getCollectionNFT()
    }

    init(dataProvider: CatalogDataProviderProtocol) {
        self.dataProvider = dataProvider
    }

    func fetchCollections(completion: @escaping ([NFTCollection]) -> Void) {
        dataProvider.fetchNFTCollection { [weak self] _ in
            self?.viewController?.reloadTableView()
        }
    }

    func getDataSource() -> [NFTCollection] {
        return self.dataSource
    }

    func sortNFTS(by: NFTCollectionsSort) {
        dataProvider.sortNFTCollections(by: by)
    }
}
