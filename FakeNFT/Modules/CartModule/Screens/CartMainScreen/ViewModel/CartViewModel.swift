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
    
    private var dataStore: DataStorageManagerProtocol
    private var networkClient: NetworkClient
    
    init(dataStore: DataStorageManagerProtocol, networkClient: NetworkClient) {
        self.dataStore = dataStore
        self.networkClient = networkClient
        
        bind()
    }
        
    func setupSortValue(_ sortBy: CartSortValue) {
//        dataStore.cartSortDescriptor = sortBy
    }
    
    // TODO: Do not remove: new sort logic
//    func setupSortValue2(_ sortBy: SortDescriptorType) {
//        let manager = DataStorageManager()
//        manager.currentSortDescriptor = sortBy
//    }
    
    func deleteItem(_ item: SingleNft?) {
        dataStore.deleteItem(item)
    }
    
    func reload() {
//        let storedNftItems = dataStore.getCartRowItems()
//        storedNftItems.forEach { singleNft in
//            let request = RequestConstructor.constructNftCollectionRequest(method: .get, collectionId: singleNft.id)
//            requestResult = .loading
//            networkClient.send(request: request, type: SingleNft.self) { [weak self] result in
//                guard let self else { return }
//                switch result {
//                case .success(let data):
//                    self.dataStore.addCartRowItem(data)
//                    requestResult = nil
//                case .failure(let error):
//                    self.cartError = error
//                    requestResult = nil
//                }
//            }
//        }
    }
    
    func add() {
        dataStore.addItem(
            SingleNft(createdAt: "test1",
                      name: "test1",
                      images: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png"],
                      rating: Int.random(in: 0...5),
                      description: "test1",
                      price: Float.random(in: 0...100),
                      author: "test",
                      id: "\(Int.random(in: 0...100000))"))
    }
}

// MARK: - Ext Private methods
private extension CartViewModel {
    func bind() {
        
        // TODO: works with test add
        dataStore.getAnyPublisher(.cartItems)
            .compactMap({ items -> [SingleNft] in
                return items.compactMap({ $0 as? SingleNft })
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] singleNfts in
                self?.visibleRows = singleNfts
            }
            .store(in: &cancellables)
        
        
        // TODO: Do not remove, initial logic
//        dataStore.cartDataPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] in
//                guard let self else { return }
//                self.visibleRows = $0
//            }
//            .store(in: &cancellables)
    }
}
