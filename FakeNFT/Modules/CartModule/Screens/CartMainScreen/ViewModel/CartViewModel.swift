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
    private var networkClient: NetworkClient
    
    init(dataStore: DataStorageProtocol, networkClient: NetworkClient) {
        self.dataStore = dataStore
        self.networkClient = networkClient
        
        bind()
        load()
    }
    
    func setupSortValue(_ sortBy: CartSortValue) {
        dataStore.sortDescriptor = sortBy
    }
    
    func deleteItem(with id: UUID?) {
        guard let id else { return }
        visibleRows.removeAll(where: { $0.id == id })
    }
}

// MARK: - Ext Private methods
private extension CartViewModel {
    func bind() {
        dataStore.dataPublisher
            .sink { self.visibleRows = $0 }
            .store(in: &cancellables)
    }
    
    func load() {
        // MARK: Replace for loading from userProfile
        let request = RequestConstructor.constructNftCollectionRequest(method: .get)
        networkClient.send(request: request, type: [NftSingleCollection].self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let convertedData = self.convert(data)
                    self.addRowsToStorage(convertedData)
                    self.visibleRows = self.dataStore.getCartRowItems()
                }
                
            case .failure(let error):
                print("error is: \(error)")
            }
        }
    }
    
    func convert(_ singeNft: [NftSingleCollection]) -> [CartRow] {
        var rows: [CartRow] = []
        
        singeNft.forEach { collection in
            let row = CartRow(
                imageName: collection.images.first ?? "",
                nftName: collection.name,
                rate: collection.rating,
                price: collection.price,
                coinName: "ETF")
            // MARK: connect to chosen currency
            
            rows.append(row)
        }
        
        return rows
    }
    
    func addRowsToStorage(_ rows: [CartRow]) {
        rows.forEach { row in
            dataStore.addCartRowItem(row)
        }
    }
}
