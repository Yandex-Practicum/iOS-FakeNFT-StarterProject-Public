//
//  TrashFactory.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 09.02.2024.
//

import UIKit

final class TrashFactory {
    func create(with context: Context) -> UIViewController {
        let presenter = TrashPresenter(servicesAssembly: context.servicesAssembly)
        let controller = TrashViewController(presenter: presenter)
        
        presenter.view = controller
        
        return controller
    }
}
// MARK: - Context
extension TrashFactory {
    struct Context {
        let servicesAssembly: ServicesAssembly
    }
}
