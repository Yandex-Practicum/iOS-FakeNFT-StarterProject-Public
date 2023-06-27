//
//  CartDataSourceManager.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

protocol DataSourceManagerProtocol {
    var delegate: CartCellDelegate? { get set }
    func createDataSource(for tableView: UITableView, with data: [NftSingleCollection])
    func updateTableView(with data: [NftSingleCollection])
    func getRowHeight(for tableView: UITableView) -> CGFloat
}

final class CartDataSourceManager {
    typealias DataSource = UITableViewDiffableDataSource<CartSection, NftSingleCollection>
    typealias Snapshot = NSDiffableDataSourceSnapshot<CartSection, NftSingleCollection>
    
    private var dataSource: DataSource?
    weak var delegate: CartCellDelegate?
}

extension CartDataSourceManager: DataSourceManagerProtocol {
    func createDataSource(for tableView: UITableView, with data: [NftSingleCollection]) {
        dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
            return self?.cell(tableView: tableView, indexPath: indexPath, item: item)
        }
        
        dataSource?.defaultRowAnimation = .fade
        dataSource?.apply(createSnapshot(from: data))
    }
    
    func updateTableView(with data: [NftSingleCollection]) {
        dataSource?.apply(createSnapshot(from: data), animatingDifferences: true, completion: nil)
    }
    
    func getRowHeight(for tableView: UITableView) -> CGFloat {
        return tableView.frame.height / 4.0
    }
}

private extension CartDataSourceManager {
    func cell(tableView: UITableView, indexPath: IndexPath, item: NftSingleCollection) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as? CartTableViewCell
        else { return UITableViewCell(frame: .zero) }
        cell.viewModel = CartCellViewModel(cartRow: item)
        cell.delegate = delegate
        return cell
    }
    
    func createSnapshot(from data: [NftSingleCollection]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
}
