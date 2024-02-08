//
//  TrashView.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 09.02.2024.
//

import UIKit

final class TrashView: UIView {
    // MARK: - UIComponents

    private let tableView = UITableView()
    private let tableManager = TrashTableManager()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    func configure(with model: Model) {
        tableManager.tableView = tableView
        tableManager.configure(with: .init(items: model.items))
    }
}

// MARK: - Private Methods

private extension TrashView {
    func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Model

extension TrashView {
    struct Model {
        let items: [TableCellItem]
    }
}
