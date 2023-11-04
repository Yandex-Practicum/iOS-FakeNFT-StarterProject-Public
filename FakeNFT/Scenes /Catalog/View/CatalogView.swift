//
//  CatalogView.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 04.11.2023.
//

import UIKit

final class CatalogView: UIView {
    
    private let reuseIdentifier = Constants.catalogTableViewCellIdentifier
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        addSubview(tableView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension CatalogView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let text = "Pictures"
        let counter = 10
        
        cell.configureCell(text: text, counter: counter)
        
        return cell
    }
}

extension CatalogView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
}
