//
//  CartTableViewHelper.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 31.07.2023.
//

import UIKit

protocol CartTableViewHelperDelegate: AnyObject {
    var order: OrderViewModel? { get }
    func removeNft(row: Int, nftImage: UIImage?)
}

protocol CartTableViewHelperProtocol: UITableViewDataSource, UITableViewDelegate {
    var delegate: CartTableViewHelperDelegate? { get set }
}

final class CartTableViewHelper: NSObject {
    weak var delegate: CartTableViewHelperDelegate?
}

// MARK: - CartTableViewHelperProtocol
extension CartTableViewHelper: CartTableViewHelperProtocol {
    // MARK: - UITableViewDelegate
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        140
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }
        let cell: CartTableViewCell = tableView.cellForRow(indexPath: indexPath)
        self.delegate?.removeNft(row: indexPath.row, nftImage: cell.nft?.image)
    }

    // MARK: - UITableViewDataSource
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        self.delegate?.order?.count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let nft = self.delegate?.order?[indexPath.row] else { return UITableViewCell() }
        let cell: CartTableViewCell = tableView.dequeueReusableCell()
        cell.nft = nft
        return cell
    }
}
