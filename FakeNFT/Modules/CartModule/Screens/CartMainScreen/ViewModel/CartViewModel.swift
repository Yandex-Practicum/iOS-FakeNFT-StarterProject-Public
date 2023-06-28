//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import Foundation
import Combine

final class CartViewModel {
    var request: NetworkRequest?
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private (set) var visibleRows: [NftSingleCollection] = []
    @Published private (set) var cartError: Error?
    
    private var dataStore: DataStorageProtocol
    private var networkClient: NetworkClient
    
    init(dataStore: DataStorageProtocol, networkClient: NetworkClient) {
        self.dataStore = dataStore
        self.networkClient = networkClient
        
        bind()
    }
    
    func setupSortValue(_ sortBy: CartSortValue) {
        dataStore.sortDescriptor = sortBy
    }
    
    func deleteItem(with id: String?) {
        guard let id else { return }
        visibleRows.removeAll(where: { $0.id == id })
    }
    
    func load() {
        // MARK: Replace for loading from userProfile
        let request = RequestConstructor.constructNftCollectionRequest(method: .get)
        networkClient.send(request: request, type: [NftSingleCollection].self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.addRowsToStorage(data)
            case .failure(let error):
                self.cartError = error
            }
        }
    }
}

// MARK: - Ext Private methods
private extension CartViewModel {
    func bind() {
        dataStore.dataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.visibleRows = $0
            }
            .store(in: &cancellables)
    }
    
    func addRowsToStorage(_ rows: [NftSingleCollection]) {
        rows.forEach { row in
            dataStore.addCartRowItem(row)
        }
    }
}
