//
//  TrashTableManager.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 09.02.2024.
//

import UIKit

final class TrashTableManager: NSObject {
    private var model: Model?
    
    weak var tableView: UITableView?
    
    func configure(with model: Model) {
        self.model = model

        tableView?.dataSource = self
        tableView?.delegate = self

        tableView?.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension TrashTableManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createItemCell(at: indexPath)
    }
}

// MARK: - UITableViewDataSource

extension TrashTableManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private Methods

private extension TrashTableManager {
    func createItemCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let item = model?.items[indexPath.row] else { return UITableViewCell() }

        let cell = UITableViewCell()
        
        cell.textLabel?.text = item.title
        cell.imageView?.image = item.image
        
        return cell
    }
}

// MARK: - Model

extension TrashTableManager {
    struct Model {
        let items: [TableCellItem]
    }
}
