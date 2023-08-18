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
    func viewDidRequestCollectionScreen(collectionIndex: Int) -> CollectionScreenViewController
    func viewMadeFetchRequest()
    func viewDidRequestDataByIndex(index: Int) -> CatalogDataModel
}
