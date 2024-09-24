//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Александра Коснырева on 09.09.2024.
//

import Foundation
import UIKit

final class CatalogueViewController: UIViewController {
    
    //let servicesAssembly: ServicesAssembly
    
    //    init(servicesAssembly: ServicesAssembly) {
    //        self.servicesAssembly = servicesAssembly
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    private let image: UIImage = {
        let image = UIImage(named: "PeachPlaceholder")
        return image ?? UIImage()
    }()
    
    private let sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.isEnabled = true
        button.image = UIImage(named: "Sort")
        button.tintColor = .black
        return button
    }()
    
    private let catalogueTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        
        tableView.register(CatalogueTableViewCell.self, forCellReuseIdentifier: CatalogueTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createNavigation()
        catalogueTableView.dataSource = self
        catalogueTableView.delegate = self
        setupUI()
        sortButton.target = self
        sortButton.action = #selector(showSortWindow(_:))
        
    }
    
    private func createNavigation() {
        guard let navigationController = navigationController else {return}
        navigationItem.rightBarButtonItem = sortButton
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.backIndicatorImage = UIImage()
        navigationController.navigationBar.backgroundColor = .white
    }
    
    private func setupUI() {
        catalogueTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(catalogueTableView)
        NSLayoutConstraint.activate([
            catalogueTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            catalogueTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            catalogueTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            catalogueTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func showSortWindow(_ sender: UIBarButtonItem) {
        let alert = AlertVC(title: "Сортировка", message: .none, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        let sortByTitle = UIAlertAction(title: "По названию", style: .default, handler: nil)
        let sortByCount = UIAlertAction(title: "По количеству NFT", style: .default, handler: nil)
        alert.setCustomColor(UIColor.black.withAlphaComponent(0.5))
        alert.addAction(cancelAction)
        alert.addAction(sortByTitle)
        alert.addAction(sortByCount)
        present(alert, animated: true)
    }
    
    private func showChoosenNFT() {
        let choosenVC = ChoosenNFTViewController()
        choosenVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(choosenVC, animated: true)
    }
}

extension CatalogueViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogueTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CatalogueTableViewCell else {return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            cell.configueCover(image: UIImage(named: "PeachPlaceholder") ?? image )
        case 1:
            cell.configueCover(image: UIImage(named: "BluePlaceholder") ?? image )
        case 2:
            cell.configueCover(image: UIImage(named: "BrownPlaceholder") ?? image )
        case 3:
            cell.configueCover(image: UIImage(named: "GreenPlaceholder") ?? image )
        default:
            cell.configueCover(image: UIImage(named: "BrownPlaceholder") ?? image )
        }
        cell.selectionStyle = .none
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        179
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
}

extension CatalogueViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let label = UILabel(frame: CGRect(x: 0, y: 4, width: tableView.frame.width, height: 25))
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        switch section {
        case 0:
            label.text = "Peach (11)"
        case 1:
            label.text = "Blue (6)"
        case 2:
            label.text = "Brown (8)"
        case 3:
            label.text = ""
            footerView.isHidden = true
        default:
            label.text = ""
        }
        footerView.addSubview(label)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        47
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showChoosenNFT()
    }
}


