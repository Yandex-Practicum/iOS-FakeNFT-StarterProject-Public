//
//  CatalogViewProtocol.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import UIKit

protocol CatalogViewControllerProtocol: AnyObject {
    func updateTableView()
    func showProgressHud()
    func removeHud()
}

protocol CatalogViewPresenterProtocol {
    var catalogCount: Int { get }
    var alertActions: [AlertActionModel] { get }
    func injectViewController(catalogViewController: CatalogViewControllerProtocol)
    func viewDidLoad()
    func didTapCell(at index: Int) -> CollectionScreenViewController
    func viewStartedCellConfiguration(at index: Int) -> CatalogDataModel
    func viewWillSetImage(with link: String) -> URL?
    func tableWillEnd(currentIndex: Int)
}
