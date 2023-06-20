//
//  CartDataSourceManager.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

protocol DataSourceManagerProtocol {
    func createDataSource(for tableView: UITableView, with data: [CartRow])
    func updateTableView(with data: [CartRow])
    func getRowHeight(for tableView: UITableView) -> CGFloat
}

final class CartDataSourceManager {
    typealias DataSource = UITableViewDiffableDataSource<CartSection, CartRow>
    typealias Snapshot = NSDiffableDataSourceSnapshot<CartSection, CartRow>
    
    private var dataSource: DataSource?
    
}

extension CartDataSourceManager: DataSourceManagerProtocol {
    func createDataSource(for tableView: UITableView, with data: [CartRow]) {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            return self.cell(tableView: tableView, indexPath: indexPath, item: item)
        }
        
        dataSource?.defaultRowAnimation = .fade
        dataSource?.apply(createSnapshot(from: data))
    }
    
    func updateTableView(with data: [CartRow]) {
        dataSource?.apply(createSnapshot(from: data), animatingDifferences: true, completion: nil)
    }
    
    func getRowHeight(for tableView: UITableView) -> CGFloat {
        return tableView.frame.height / 4.0
    }
}

private extension CartDataSourceManager {
    func cell(tableView: UITableView, indexPath: IndexPath, item: CartRow) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as? CartTableViewCell
        else { return UITableViewCell(frame: .zero) }
        cell.applyCellModel(from: item)
        return cell
    }
    
    func createSnapshot(from data: [CartRow]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
}
