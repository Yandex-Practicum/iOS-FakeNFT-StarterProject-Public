//
//  NFTListView.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import UIKit

final class NFTListView: UIView {
    private let cellSelectedHandler: EventHandler<IndexPath>
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var items: [NFTCollectionModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    init(cellSelectedHandler: @escaping EventHandler<IndexPath>) {
        self.cellSelectedHandler = cellSelectedHandler
        super.init(frame: .null)
        configureTableView()
    }

    required init?(coder: NSCoder) {
        fatalError(
            "NFTListView -> init(coder:) has not been implemented"
        )
    }

    private func configureTableView() {
        tableView.register(
            NFTListCell.self,
            forCellReuseIdentifier: String(describing: NFTListCell.self)
        )

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        addSubview(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 108),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with modelItems: [NFTCollectionModel]) {
        items = modelItems
    }
}

extension NFTListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelectedHandler(indexPath)
    }
}

extension NFTListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: NFTListCell.self)
        ) as? NFTListCell else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]

        cell.configure(
            with:
                .init(
                    imageUrl: item.cover,
                    collectionDescription: item.name,
                    collectionItems: item.nfts.count
                )
        )
        return cell
    }
}
