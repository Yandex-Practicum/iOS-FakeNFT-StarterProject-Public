//
//  CartTableViewHelper.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 31.07.2023.
//

import UIKit

protocol CartTableViewHelperDelegate: AnyObject {
    var order: [NFTCartCellViewModel]? { get }
}

protocol CartTableViewHelperProtocol: UITableViewDataSource, UITableViewDelegate {
    var delegate: CartTableViewHelperDelegate? { get set }
}

final class CartTableViewHelper: NSObject {
    weak var delegate: CartTableViewHelperDelegate?
}

// MARK: - CartTableViewHelperProtocol
extension CartTableViewHelper: CartTableViewHelperProtocol {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        140
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
