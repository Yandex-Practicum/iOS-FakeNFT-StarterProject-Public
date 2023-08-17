//
//  CatalogViewProtocol.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import UIKit

protocol CatalogViewControllerProtocol: AnyObject {
    func updateTableView()
    func removeHud()
}

protocol CatalogViewPresenterProtocol {
    var catalogCount: Int { get }
    var alertActions: [AlertActionModel] { get }
    func createCollectionScreen(collectionIndex: Int) -> CollectionScreenViewController
    func updateCatalogData()
    func makeFetchRequest()
    func takeDataByIndex(index: Int) -> CatalogDataModel
}
