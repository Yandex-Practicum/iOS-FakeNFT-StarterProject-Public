//
//  TrashPresenter.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 09.02.2024.
//

import Foundation

protocol TrashPresenterProtocol {
    
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
    
}
