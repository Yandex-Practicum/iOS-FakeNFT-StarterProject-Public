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
    
    @Published private (set) var visibleRows: [SingleNftModel] = []
    @Published private (set) var cartError: NetworkError?
    @Published private (set) var requestResult: RequestResult?
            
    private var dataStore: DataStorageManagerProtocol
    private var networkClient: NetworkClient
    
    init(dataStore: DataStorageManagerProtocol, networkClient: NetworkClient) {
        self.dataStore = dataStore
        self.networkClient = networkClient
        
        bind()
    }
        
    func setupSortValue(_ descriptor: NftSortValue) {
        dataStore.nftSortDescriptor = descriptor
        reload()
    }
    
    func deleteItem(_ id: String?) {
        guard let id else { return }
        dataStore.toggleIsStored(id)
    }
    
    func reload() {
        let storedNftItems = dataStore.getItems(.storedItems).compactMap({ $0 as? String })
        updateUI(storedNftItems)
    }
}

// MARK: - Ext bind
private extension CartViewModel {
    func bind() {
        dataStore.getAnyPublisher(.storedItems)
            .compactMap({ items -> [String] in
                return items.compactMap({ $0 as? String })
            })
            .sink { [weak self] storedIds in
                self?.updateUI(storedIds)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Ext network publisher
private extension CartViewModel {
    func updateUI(_ ids: [String]) {
        visibleRows = dataStore.getItems(.singleNftItems)
            .compactMap({ $0 as? SingleNftModel })
            .filter({ ids.contains($0.id) })
    }
}
