//
//  TableViewDataSource.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

protocol CartDataSourceManagerProtocol {
    typealias CartDataSource = UITableViewDiffableDataSource<NftTableViewSection, SingleNft>
    typealias CartSnapshot = NSDiffableDataSourceSnapshot<NftTableViewSection, SingleNft>
    var onDeleteHandler: ((String?) -> Void)? { get set }
    func createCartDataSource(for tableView: UITableView, with data: [SingleNft])
    func updateTableView(with data: [SingleNft])
    func getCartRowHeight(for tableView: UITableView) -> CGFloat
}

protocol CatalogDataSourceManagerProtocol {
    typealias CatalogDataSource = UITableViewDiffableDataSource<NftTableViewSection, NftCollection>
    typealias CatalogSnapshot = NSDiffableDataSourceSnapshot<NftTableViewSection, NftCollection>
    func createCatalogDataSource(for tableView: UITableView, with data: [NftCollection])
    func updateTableView(with data: [NftCollection])
    func getCatalogRowHeight(for tableView: UITableView) -> CGFloat
}

final class TableViewDataSource {
    private var cartDataSource: CartDataSource?
    private var catalogDataSource: CatalogDataSource?
    
    var onDeleteHandler: ((String?) -> Void)?
}

// MARK: - Ext CartDataSourceManagerProtocol
extension TableViewDataSource: CartDataSourceManagerProtocol {
    func createCartDataSource(for tableView: UITableView, with data: [SingleNft]) {
        cartDataSource = CartDataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
            return self?.cartCell(tableView: tableView, indexPath: indexPath, item: item)
        }
        
        cartDataSource?.defaultRowAnimation = .fade
        cartDataSource?.apply(createCartSnapshot(from: data))
    }
    
    func updateTableView(with data: [SingleNft]) {
        cartDataSource?.apply(createCartSnapshot(from: data), animatingDifferences: true, completion: nil)
    }
    
    func getCartRowHeight(for tableView: UITableView) -> CGFloat {
        return tableView.frame.height / 4.0
    }
}

// MARK: - Ext CatalogDataSourceManagerProtocol
extension TableViewDataSource: CatalogDataSourceManagerProtocol {
    func createCatalogDataSource(for tableView: UITableView, with data: [NftCollection]) {
        catalogDataSource = CatalogDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            return self?.catalogCell(tableView: tableView, indexPath: indexPath, item: itemIdentifier)
        })
        
        catalogDataSource?.defaultRowAnimation = .fade
        catalogDataSource?.apply(createCatalogSnapshot(from: data))
    }
    
    func updateTableView(with data: [NftCollection]) {
        catalogDataSource?.apply(createCatalogSnapshot(from: data), animatingDifferences: true, completion: nil)
    }
    
    func getCatalogRowHeight(for tableView: UITableView) -> CGFloat {
        return tableView.frame.height / 3.0
    }
}

// MARK: - Ext Cells
private extension TableViewDataSource {
    func cartCell(tableView: UITableView, indexPath: IndexPath, item: SingleNft) -> UITableViewCell {
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
    
    func catalogCell(tableView: UITableView, indexPath: IndexPath, item: NftCollection) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogTableViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as? CatalogTableViewCell
        else { return UITableViewCell(frame: .zero) }
        cell.viewModel = CatalogCellViewModel(catalogRows: item)
        return cell
    }
}

// MARK: - Ext Shapshots
private extension TableViewDataSource {
    func createCartSnapshot(from data: [SingleNft]) -> CartSnapshot {
        var snapshot = CartSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
    
    func createCatalogSnapshot(from data: [NftCollection]) -> CatalogSnapshot {
        var snapshot = CatalogSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
}
