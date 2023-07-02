//
//  TableViewDataSource.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

protocol CartDataSourceManagerProtocol {
    typealias CartDataSource = UITableViewDiffableDataSource<NftTableViewSection, NftSingleCollection>
    typealias CartSnapshot = NSDiffableDataSourceSnapshot<NftTableViewSection, NftSingleCollection>
    var onDeleteHandler: ((String?) -> Void)? { get set }
    func createCartDataSource(for tableView: UITableView, with data: [NftSingleCollection])
    func updateTableView(with data: [NftSingleCollection])
    func getRowHeight(for tableView: UITableView) -> CGFloat
}

protocol CatalogDataSourceManagerProtocol {
    typealias CatalogDataSource = UITableViewDiffableDataSource<NftTableViewSection, NftCollections>
    typealias CatalogSnapshot = NSDiffableDataSourceSnapshot<NftTableViewSection, NftCollections>
    func createCatalogDataSource(for tableView: UITableView, with data: [NftCollections])
    func updateTableView(with data: [NftCollections])
}

final class TableViewDataSource {
    private var cartDataSource: CartDataSource?
    private var catalogDataSource: CatalogDataSource?
    
    var onDeleteHandler: ((String?) -> Void)?
}

// MARK: - Ext CartDataSourceManagerProtocol
extension TableViewDataSource: CartDataSourceManagerProtocol {
    func createCartDataSource(for tableView: UITableView, with data: [NftSingleCollection]) {
        cartDataSource = CartDataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
            return self?.cartCell(tableView: tableView, indexPath: indexPath, item: item)
        }
        
        cartDataSource?.defaultRowAnimation = .fade
        cartDataSource?.apply(createCartSnapshot(from: data))
    }
    
    func updateTableView(with data: [NftSingleCollection]) {
        cartDataSource?.apply(createCartSnapshot(from: data), animatingDifferences: true, completion: nil)
    }
    
    func getRowHeight(for tableView: UITableView) -> CGFloat {
        return tableView.frame.height / 4.0
    }
}

// MARK: - Ext CatalogDataSourceManagerProtocol
extension TableViewDataSource: CatalogDataSourceManagerProtocol {
    func createCatalogDataSource(for tableView: UITableView, with data: [NftCollections]) {
        catalogDataSource = CatalogDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            return self?.catalogCell(tableView: tableView, indexPath: indexPath, item: itemIdentifier)
        })
        
        catalogDataSource?.defaultRowAnimation = .fade
        catalogDataSource?.apply(createCatalogSnapshot(from: data))
    }
    
    func updateTableView(with data: [NftCollections]) {
        catalogDataSource?.apply(createCatalogSnapshot(from: data), animatingDifferences: true, completion: nil)
    }
}

// MARK: - Ext Cells
private extension TableViewDataSource {
    func cartCell(tableView: UITableView, indexPath: IndexPath, item: NftSingleCollection) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as? CartTableViewCell
        else { return UITableViewCell(frame: .zero) }
        cell.viewModel = CartCellViewModel(cartRow: item)
        cell.onDelete = { [weak self] id in
            self?.onDeleteHandler?(id)
        }
        
        return cell
    }
    
    func catalogCell(tableView: UITableView, indexPath: IndexPath, item: NftCollections) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogTableViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as? CatalogTableViewCell
        else { return UITableViewCell(frame: .zero) }
        
        return cell
    }
}

// MARK: - Ext Shapshots
private extension TableViewDataSource {
    func createCartSnapshot(from data: [NftSingleCollection]) -> CartSnapshot {
        var snapshot = CartSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
    
    func createCatalogSnapshot(from data: [NftCollections]) -> CatalogSnapshot {
        var snapshot = CatalogSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
}
