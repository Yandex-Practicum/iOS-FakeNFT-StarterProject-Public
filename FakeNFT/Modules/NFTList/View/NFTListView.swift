//
//  NFTListView.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import UIKit

final class NFTListView: UIView {
    private let cellSelected: (IndexPath) -> Void
    private let tableView = UITableView()
    private var items: [NFTCollectionModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    init(cellSelected: @escaping (IndexPath) -> Void) {
        self.cellSelected = cellSelected
        super.init(frame: .null)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.register(NFTListCell.self, forCellReuseIdentifier: NFTListCell.reuseIdentifier)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 108),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}

extension NFTListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected(indexPath)
    }
}

extension NFTListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NFTListCell.reuseIdentifier
        ) as? NFTListCell else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]

        cell.configure(.init(imageUrl: item.cover,
                             collectionDescription: item.name,
                             collectionItems: item.nfts.count))
        return cell
    }
}

extension NFTListView {
    struct Configuration {
        let items: [NFTCollectionModel]
    }

    func configure(_ configuration: Configuration) {
        items = configuration.items
    }
}
