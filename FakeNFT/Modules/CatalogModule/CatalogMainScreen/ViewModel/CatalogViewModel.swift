//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 02.07.2023.
//

import Foundation
import Combine

final class CatalogViewModel {
    
    @Published private (set) var visibleRows: [NftCollections] = []
    @Published private (set) var catalogError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var dataStore: CatalogDataStorageProtocol
    private var networkClient: NetworkClient
    
    init(dataStore: CatalogDataStorageProtocol, networkClient: NetworkClient) {
        self.dataStore = dataStore
        self.networkClient = networkClient
        bind()
    }
    
    func setupSortValue(_ sortBy: CatalogSortValue) {
        dataStore.catalogSortDescriptor = sortBy
    }
    
    func load() {
        // MARK: Replace for loading from userProfile
        let request = RequestConstructor.constructCatalogRequest(method: .get)
//        requestResult = .loading
        networkClient.send(request: request, type: [NftCollections].self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.addRowsToStorage(data)
//                requestResult = nil
            case .failure(let error):
                self.catalogError = error
//                requestResult = nil
            }
        }
    }
}

// MARK: - Ext Private
private extension CatalogViewModel {
    func bind() {
        dataStore.catalogDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.visibleRows = $0
            }
            .store(in: &cancellables)
    }
    
    func addRowsToStorage(_ rows: [NftCollections]) {
        rows.forEach { row in
            dataStore.addCatalogRowItem(row)
        }
    }
}
