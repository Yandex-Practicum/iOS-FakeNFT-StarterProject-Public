//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit

final class CatalogViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypLightGrey
    }
    

    

}

extension CatalogViewController: CoordinatableProtocol {
    // Здесь можно будет настроить реализацию событий из протокола, который видит координатор (returnOnCancel, returnOnSuccess и пр.)
}
