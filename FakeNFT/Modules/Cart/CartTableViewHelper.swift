//
//  CartTableViewHelper.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 31.07.2023.
//

import UIKit

protocol CartTableViewHelperDelegate: AnyObject {}

protocol CartTableViewHelperProtocol: UITableViewDataSource, UITableViewDelegate {
    var delegate: CartTableViewHelperDelegate? { get set }
}

final class CartTableViewHelper: NSObject {
    weak var delegate: CartTableViewHelperDelegate?
}

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
        1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: CartTableViewCell = tableView.dequeueReusableCell()
        cell.nft = NFTCartCellViewModel(id: 1, name: "Хыхыхы", image: nil, rating: 2, price: 2)
        return cell
    }
}
