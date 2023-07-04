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
    
    @Published private (set) var visibleRows: [SingleNft] = []
    @Published private (set) var cartError: Error?
    @Published private (set) var requestResult: RequestResult?
    
    private var idToDelete: String?
    
    private var dataStore: CartDataStorageProtocol
    private var networkClient: NetworkClient
    
    init(dataStore: CartDataStorageProtocol, networkClient: NetworkClient) {
        self.dataStore = dataStore
        self.networkClient = networkClient
        
        bind()
    }
        
    func setupSortValue(_ sortBy: CartSortValue) {
        dataStore.cartSortDescriptor = sortBy
    }
    
    func deleteItem(with id: String?) {
        guard let id else { return }
        dataStore.deleteItem(with: id)
    }
    
    func load() {
        // MARK: Replace for loading from userProfile        
        let request = RequestConstructor.constructNftCollectionRequest(method: .get)
        requestResult = .loading
        networkClient.send(request: request, type: [SingleNft].self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.addRowsToStorage(data)
                requestResult = nil
            case .failure(let error):
                self.cartError = error
                requestResult = nil
            }
        }
    }
}

// MARK: - Ext Private methods
private extension CartViewModel {
    func bind() {
        dataStore.cartDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.visibleRows = $0
            }
            .store(in: &cancellables)
    }
    
    func addRowsToStorage(_ rows: [SingleNft]) {
        rows.forEach { row in
            dataStore.addCartRowItem(row)
        }
    }
}
