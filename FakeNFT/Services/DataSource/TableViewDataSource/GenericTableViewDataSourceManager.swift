//
//  GenericTableViewDataSourceManager.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 09.07.2023.
//

import UIKit

protocol GenericTableViewDataSourceProtocol {
    func createDataSource(for tableView: UITableView, with data: [AnyHashable])
    func updateTableView(with data: [AnyHashable])
    func getRowHeight(_ module: TableViewHeight) -> CGFloat
}

protocol TableViewDataSourceCoordinatable {
    var onDeleteHandler: ((String?) -> Void)? { get set }
}

// MARK: Final class
final class TableViewDataSource: TableViewDataSourceCoordinatable {
    typealias DataSource = UITableViewDiffableDataSource<TableViewDiffableDataSourceSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<TableViewDiffableDataSourceSection, AnyHashable>
    
    var onDeleteHandler: ((String?) -> Void)?
    
    private var genericDataSource: DataSource?
}

// MARK: - Ext GenericTableViewDataSourceProtocol
extension TableViewDataSource: GenericTableViewDataSourceProtocol {
    func createDataSource(for tableView: UITableView, with data: [AnyHashable]) {
        genericDataSource = DataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            return self?.tableViewCell(tableView, at: indexPath, with: itemIdentifier)
        })
        
        updateTableView(with: data)
    }
    
    func updateTableView(with data: [AnyHashable]) {
        genericDataSource?.apply(createSnapshot(from: data), animatingDifferences: true, completion: nil)
    }
    
    func getRowHeight(_ module: TableViewHeight) -> CGFloat {
        return module.height
    }
}

// MARK: - Ext private
private extension TableViewDataSource {
    func tableViewCell(_ tableView: UITableView, at indexPath: IndexPath, with item: AnyHashable) -> UITableViewCell {
        switch item.base {
        case let singleNft as SingleNft:
            return cartCell(tableView: tableView, indexPath: indexPath, item: singleNft)
        case let nftCollection as NftCollection:
            return catalogCell(tableView: tableView, indexPath: indexPath, item: nftCollection)
        case let userNftDescription as ProfileModel:
            return profileCell(tableView: tableView, indexPath: indexPath, item: userNftDescription)
        case let myNftCell as VisibleSingleNfts:
            return profileMyNftCell(tableView: tableView, indexPath: indexPath, item: myNftCell)
        default:
            return UITableViewCell(frame: .zero)
        }
    }
    
    // MARK: Cells
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
        cell.selectionStyle = .none
        return cell
    }
    
    func profileCell(tableView: UITableView, indexPath: IndexPath, item: ProfileModel) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileMainTableViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as? ProfileMainTableViewCell
        else { return UITableViewCell(frame: .zero) }
        cell.viewModel = ProfileTableCellViewModel(descriptionRow: item)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func profileMyNftCell(tableView: UITableView, indexPath: IndexPath, item: VisibleSingleNfts) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileMyNftTableViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as? ProfileMyNftTableViewCell
        else { return UITableViewCell(frame: .zero) }
        cell.viewModel = ProfileMyNftCellViewModel(cellModel: item)
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: Snapshot
    func createSnapshot(from data: [AnyHashable]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        return snapshot
    }
}
