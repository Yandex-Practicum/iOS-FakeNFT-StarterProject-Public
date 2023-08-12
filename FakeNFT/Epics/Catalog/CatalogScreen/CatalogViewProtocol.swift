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
    func configureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func createCollectionScreen(collectionIndex: Int) -> CollectionScreenViewController
    func catalogCount() -> Int
    func updateCatalogData()
    func makeFetchRequest()
}
