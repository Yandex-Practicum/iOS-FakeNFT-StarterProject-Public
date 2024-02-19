//
//  TrashPresenter.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 09.02.2024.
//

import UIKit

protocol TrashPresenterProtocol {
    var title: String { get }
        
    func viewLoaded()
    }

final class TrashPresenter {
    weak var view: TrashViewProtocol?
    
    private let servicesAssembly: ServicesAssembly
    
    init (servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
}

// MARK: - TrashPresenterProtocol

extension TrashPresenter: TrashPresenterProtocol {
    var title: String {
            "Корзина"
        }
    
        func viewLoaded() {
            let items: [TableCellItem] = [
                .init(
                    title: "Элемент 1",
                    image: UIImage(systemName: "trash.fill") ?? .init()
                ),
                .init(
                    title: "Элемент 2",
                    image: UIImage(systemName: "trash.fill") ?? .init()
                )
           ]
    
           view?.updateUI(
               with: .init(
                   items: items
               )
           )
        }
     }
