//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 02.07.2023.
//

import Foundation
import Combine

final class CatalogViewModel {
    
    @Published private (set) var visibleRows: [CatalogMainScreenCollection] = []
    @Published private (set) var catalogError: Error?
    @Published private (set) var requestResult: RequestResult?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var dataStore: DataStorageManagerProtocol
    private var networkClient: NetworkClient
    
    init(dataStore: DataStorageManagerProtocol, networkClient: NetworkClient) {
        self.dataStore = dataStore
        self.networkClient = networkClient
        bind()
    }
    
    func setupSortValue(_ sortBy: CatalogSortValue) {
//        dataStore.catalogSortDescriptor = sortBy
    }
    
    func load() {
        let request = RequestConstructor.constructCatalogRequest(method: .get)
        requestResult = .loading
        catalogError = nil
        networkClient.networkPublisher(request: request, type: [CatalogMainScreenCollection].self)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.requestResult = nil
                case .failure(let error):
                    self?.catalogError = error
                    self?.requestResult = nil
                } 
        } receiveValue: { [weak self] collection in
            self?.addRowsToStorage(collection)
            self?.requestResult = nil
        }.store(in: &cancellables)
    }
}

// MARK: - Ext Private
private extension CatalogViewModel {
    func bind() {
        dataStore.getAnyPublisher(.catalogCollections)
            .compactMap({ items -> [CatalogMainScreenCollection] in
                return items.compactMap({ $0 as? CatalogMainScreenCollection })
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] singleNfts in
                self?.visibleRows = singleNfts
            }
            .store(in: &cancellables)
    }
    
    func addRowsToStorage(_ rows: [CatalogMainScreenCollection]) {
        rows.forEach { [weak dataStore] row in
            dataStore?.addItem(row)
        }
    }
}
