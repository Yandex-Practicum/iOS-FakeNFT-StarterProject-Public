//
//  CartDeleteViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.06.2023.
//

import Foundation
import Combine

final class CartDeleteViewModel {
    @Published private (set) var itemToDelete: SingleNft?
    
    private let dataStore: CartDataStorageProtocol
    
    init(dataStore: CartDataStorageProtocol) {
        self.dataStore = dataStore
    }
    
    func createUrl(from stringUrl: String?) -> URL? {
        guard let stringUrl,
              let encodedStringUrl = stringUrl.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed)
        else { return nil }
        
        return URL(string: encodedStringUrl)
    }
    
    func updateItemToDelete(with id: String?) {
        guard let id else { return }
        itemToDelete = dataStore.getCartRowItems().first(where: { $0.id == id })
    }
    
    func deleteItem(with id: String?) {
        dataStore.deleteItem(with: id)
    }
}
