//
//  CartDeleteViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.06.2023.
//

import Foundation
import Combine

final class CartDeleteViewModel {
    @Published private (set) var itemToDelete: CartRow?
    
    private let dataStore: DataStorageProtocol
    
    init(dataStore: DataStorageProtocol) {
        self.dataStore = dataStore
    }
    
    func updateItemToDelete(with id: UUID?) {
        guard let id else { return }
        itemToDelete = dataStore.getCartRowItems().first(where: { $0.id == id })
    }
    
    func deleteItem(with id: UUID?) {
        dataStore.deleteItem(with: id)
    }
}
