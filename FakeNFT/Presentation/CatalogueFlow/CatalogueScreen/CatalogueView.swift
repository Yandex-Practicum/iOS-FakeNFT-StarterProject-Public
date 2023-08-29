//
//  CatalogueView.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit

final class CatalogueView: UIView {
    let tableView: UITableView = {
        let view = UITableView()

        view.register(
            CatalogueCell.self, forCellReuseIdentifier: CatalogueCell.identifier
        )
        view.backgroundColor = .clear
        view.separatorStyle = .none

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func makeView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            tableView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            )
        ])
    }
}
