//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Vitaly on 08.10.2023.
//

import Foundation
import UIKit

final class CatalogViewController: UIViewController {

    // MARK: - Private Properties
    //
    private var textLabel: UILabel = {
        var label = UILabel()
        label.text = "Каталог"
        label.font =  UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - UIViewController(*)
    //
    override func viewDidLoad() {
        super.viewDidLoad()


        setupUI()
        view.backgroundColor = .white
        print("CatalogViewController viewDidLoad")
    }
    // MARK: - Private Methods
    //
    private func setupUI() {
        view.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
