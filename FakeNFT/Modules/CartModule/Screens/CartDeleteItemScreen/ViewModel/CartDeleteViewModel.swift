//
//  CartDeleteViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.06.2023.
//

import Foundation
import Combine

final class CartDeleteViewModel {
    @Published private (set) var itemToDelete: SingleNftModel?
    
    private let dataStore: DataStorageManagerProtocol
    
    init(dataStore: DataStorageManagerProtocol) {
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
        itemToDelete = dataStore.getItems(.singleNftItems)
            .compactMap({ $0 as? SingleNftModel })
            .first(where: { $0.id == id })
    }
    
    func deleteItem(with id: String?) {
        guard let id else { return }
        dataStore.toggleIsStored(id)
    }
}
