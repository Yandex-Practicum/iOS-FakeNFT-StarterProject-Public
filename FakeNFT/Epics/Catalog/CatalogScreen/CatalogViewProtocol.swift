//
//  CatalogViewProtocol.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import UIKit

protocol CatalogViewControllerProtocol: AnyObject {
    func updateTableView()
    func showHud()
    func removeHud()
    func show(_ view: CollectionScreenViewController)
}

protocol CatalogViewPresenterProtocol {
    var catalogCount: Int { get }
    var alertActions: [AlertActionModel] { get }
    func viewControllerInitialized(viewController: CatalogViewControllerProtocol)
    func viewDidLoad()
    func didTapCell(at index: Int)
    func viewStartedCellConfiguration(at index: Int) -> CatalogDataModel
    func viewWillSetImage(with link: String) -> URL?
    func tableWillEnd(currentIndex: Int)
}
