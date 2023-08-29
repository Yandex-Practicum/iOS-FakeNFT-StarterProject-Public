//
//  CatalogueViewController+UITableViewDataSource.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

extension CatalogueViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        30
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogueCell.identifier
        ) as? CatalogueCell else { return UITableViewCell() }

        cell.configCell()

        return cell
    }
}
