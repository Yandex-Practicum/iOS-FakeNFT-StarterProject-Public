//
//  CatalogueViewController+UITableViewDelegate.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

extension CatalogueViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let NFTScreenVC = NFTScreenVC()
        let backItem = UIBarButtonItem()
        backItem.title = String()
        NFTScreenVC.navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(NFTScreenVC, animated: true)
    }
}
