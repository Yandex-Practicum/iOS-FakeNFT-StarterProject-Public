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
    @Published private (set) var catalogError: NetworkError?
    @Published private (set) var requestResult: RequestResult?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var dataStore: DataStorageManagerProtocol
    private var networkClient: PublishersFactoryProtocol
    
    init(dataStore: DataStorageManagerProtocol, networkClient: PublishersFactoryProtocol) {
        self.dataStore = dataStore
        self.networkClient = networkClient
        bind()
    }
    
    func setupSortValue(_ descriptor: CollectionSortValue) {
        dataStore.collectionSortDescriptor = descriptor
        self.visibleRows = dataStore.getItems(.catalogCollections).compactMap({ $0 as? CatalogMainScreenCollection })
    }
    
    func load() {
        requestResult = .loading
        networkClient.getCatalogCollections()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.catalogError = error
                    self?.requestResult = nil
                }
            } receiveValue: { [weak self] collections in
                self?.addRowsToStorage(collections)
                self?.requestResult = nil
            }
            .store(in: &cancellables)
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
