//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import Foundation
import Combine

final class CartViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private (set) var visibleRows: [CartRow] = [] 
    
    private var dataStore: DataStorageProtocol
    
    init(dataStore: DataStorageProtocol) {
        self.dataStore = dataStore
        dataStore.dataPublisher
            .sink { self.visibleRows = $0 }
            .store(in: &cancellables)
    }
    
    func setupSortValue(_ sortBy: CartSortValue) {
        dataStore.sortDescriptor = sortBy
        
    }
    
    func getItems() -> [CartRow] {
        loadItems()
        return visibleRows
    }
    
    func deleteItem(with id: UUID?) {
        guard let id else { return }
        visibleRows.removeAll(where: { $0.id == id })
    }
}

private extension CartViewModel {
    func loadItems() {
        visibleRows = dataStore.getCartRowItems()
    }
    
    
    
}
