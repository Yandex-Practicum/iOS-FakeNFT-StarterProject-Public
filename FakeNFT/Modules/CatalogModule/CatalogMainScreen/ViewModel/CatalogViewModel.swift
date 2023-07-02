//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 02.07.2023.
//

import Foundation

final class CatalogViewModel {
    
    @Published private (set) var visibleRows: [NftCollections] = []
    @Published private (set) var catalogError: Error?
    
    private var dataStore: CatalogDataStorageProtocol
    private var networkClient: NetworkClient
    
    init(dataStore: CatalogDataStorageProtocol, networkClient: NetworkClient) {
        self.dataStore = dataStore
        self.networkClient = networkClient
        
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
                print("success")
                self.visibleRows = data
//                requestResult = nil
            case .failure(let error):
                print("failure")
                self.catalogError = error
//                requestResult = nil
            }
        }
    }
}
