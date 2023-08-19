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
    func injectViewController(catalogViewController: CatalogViewControllerProtocol)
    func viewDidRequestCollectionScreen(collectionIndex: Int) -> CollectionScreenViewController
    func viewMadeFetchRequest()
    func viewDidRequestDataByIndex(index: Int) -> CatalogDataModel
    func takeURL(link: String) -> URL?
}
