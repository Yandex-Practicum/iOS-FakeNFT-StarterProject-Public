//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 01.08.2023.
//

import UIKit

final class CatalogViewController: UIViewController, CatalogViewControllerProtocol {
    private var presenter: CatalogViewPresenterProtocol?
    private let sortButton = UIButton()
    private let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CatalogViewPresenter(catalogViewController: self)
        
        view.backgroundColor = .ypWhite
        configureButton()
        configureTable()
        
        makeFetchRequest()
    }
    
    func updateTableView() {
        table.reloadData()
    }
    
    private func makeFetchRequest() {
        UIBlockingProgressHUD.show()
        presenter?.makeFetchRequest()
    }
    
    func removeHud() {
        UIBlockingProgressHUD.dismiss()
    }
    
    private func configureButton() {
        sortButton.setImage(UIImage.sortButton?.withTintColor(.ypBlack), for: .normal)
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortButton)
        NSLayoutConstraint.activate([
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func configureTable() {
        if !view.contains(sortButton) { return }
        
        table.backgroundColor = .clear
        table.separatorStyle = .none
        
        table.register(CatalogViewTableCell.self)
        table.dataSource = self
        table.delegate = self
        
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            table.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.catalogCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.configureCell(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        let collectionScreen = presenter.createCollectionScreen(collectionIndex: indexPath.row)
        present(collectionScreen, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        if indexPath.row + 1 == presenter.catalogCount() {
            makeFetchRequest()
        }
    }
}
