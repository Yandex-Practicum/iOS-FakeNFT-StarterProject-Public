//
//  CatalogView.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 04.11.2023.
//

import UIKit
import Combine

protocol CatalogViewDelegate: UIViewController {
    func selectedCategory(_ model: Catalog)
}

final class CatalogView: UIView {
    
    //MARK: - Public properties
    var viewModel: CatalogViewModelProtocol!
    weak var delegate: CatalogViewDelegate?
    
    //MARK: - Private properties
    private let reuseIdentifier = Constants.catalogTableViewCellIdentifier
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    private var subscribes = [AnyCancellable]()
    
    init(frame: CGRect, viewModel: CatalogViewModelProtocol, delegate: CatalogViewDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: frame)
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupUI() {
        backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        addSubviews()
        applyConstraints()
    }
    
    private func bind() {
        viewModel.catalogPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            guard let self = self else { return }

            tableView.reloadData()
                
            }.store(in: &subscribes)
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

//MARK: - UITableViewDataSource
extension CatalogView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.catalog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let model = viewModel.catalog[indexPath.row]
        
        cell.configureCell(model: model)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CatalogView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        let model = viewModel.catalog[indexPath.row]
        delegate?.selectedCategory(model)
    }
}
