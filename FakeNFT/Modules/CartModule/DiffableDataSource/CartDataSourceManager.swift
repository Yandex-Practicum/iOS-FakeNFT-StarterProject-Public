//
//  CartDataSourceManager.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

protocol DataSourceManagerProtocol {
    func createDataSource(for tableView: UITableView)
    func getRowHeight(for indexPath: IndexPath) -> CGFloat
}

final class CartDataSourceManager {
    typealias DataSource = UITableViewDiffableDataSource<CartSection, CartRow>
    typealias Snapshot = NSDiffableDataSourceSnapshot<CartSection, CartRow>
    
    private let mockData: [CartRow] = [
        CartRow(imageName: "MockCard1", nftName: "Test 1", rate: 1, price: 3.87, coinName: "ETF"),
        CartRow(imageName: "MockCard2", nftName: "Test 2", rate: 3, price: 5.55, coinName: "BTC"),
        CartRow(imageName: "MockCard3", nftName: "Test 3", rate: 5, price: 9.86, coinName: "ETF")
    ]
    
    private var dataSource: DataSource?
    
}

extension CartDataSourceManager: DataSourceManagerProtocol {
    func createDataSource(for tableView: UITableView) {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            return self.cell(tableView: tableView, indexPath: indexPath, item: item)
        }
        
        dataSource?.defaultRowAnimation = .fade
        dataSource?.apply(createSnapshot())
    }
    
    func getRowHeight(for indexPath: IndexPath) -> CGFloat {
        return 140
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
    
    func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(mockData, toSection: .main)
        return snapshot
    }
}
