//
//  TrashFactory.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 09.02.2024.
//

import UIKit

final class TrashFactory {
    func create() -> UIViewController {
        let presenter = TrashPresenter()
        let controller = TrashViewController(presenter: presenter)
        
        presenter.view = controller
        
        return controller
    }
}
