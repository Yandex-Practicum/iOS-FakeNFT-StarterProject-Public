//
//  ProfileMyNftsViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.07.2023.
//

import Foundation
import Combine

final class ProfileMyNftsViewModel {
    @Published private (set) var visibleRows: [MyNfts] = []
    @Published private (set) var myNftError: Error?
    @Published private (set) var requestResult: RequestResult?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage: Int = 0
    private let pageSize: Int = 5
    
    private let networkClient: PublishersFactoryProtocol
    private let nftsToLoad: [String]
    private let dataStore: DataStorageManagerProtocol
    
    init(networkClient: PublishersFactoryProtocol,  nftsToLoad: [String], dataStore: DataStorageManagerProtocol) {
        self.networkClient = networkClient
        self.nftsToLoad = nftsToLoad
        self.dataStore = dataStore
        bind()
    }
    
    func isLastLoadedIndexPath(_ row: Int?) -> Bool {
        return row == (getItems().count - 1)
    }
        
    func load() {
        storageFull() ? updateVisibleRows(getItems()) : loadFromServer()
    }
    
    func setupSortDescriptor(_ descriptor: NftSortValue) {
        dataStore.nftSortDescriptor = descriptor
        updateVisibleRows(getItems())
    }
    
    private func getItems() -> [MyNfts] {
        return dataStore.getItems(.myItems).compactMap({ $0 as? MyNfts })
    }
}

// MARK: - Ext Load check
private extension ProfileMyNftsViewModel {
    func storageFull() -> Bool {
        dataStore.getItems(.myItems).count == nftsToLoad.count
    }
    
    func loadFromServer() {
        requestResult = .loading
        
        networkClient.getMyNftsPublisher(getPageOfNftsToLoad())
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.myNftError = error
                    self?.requestResult = nil
                }
            } receiveValue: { [weak self] myNfts in
                myNfts.forEach({ self?.dataStore.addItem($0) })
                self?.currentPage += 1
                self?.requestResult = nil
            }
            .store(in: &cancellables)
    }
    
    func getPageOfNftsToLoad() -> [String] {
        let startIndex = currentPage * pageSize
        let nextPage = currentPage + 1
        let endIndex = min(nextPage * pageSize, nftsToLoad.count)
        print("startIndex: \(startIndex), endIndex: \(endIndex)")
        return nftsToLoad[startIndex..<endIndex].compactMap({ $0 })
    }
}

// MARK: - Ext Bind and update
private extension ProfileMyNftsViewModel {
    func bind() {
        dataStore.getAnyPublisher(.myItems)
            .compactMap({ items -> [MyNfts] in
                return items.compactMap({ $0 as? MyNfts })
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] myNfts in
                self?.updateVisibleRows(myNfts)
            }
            .store(in: &cancellables)
    }
    
    func updateVisibleRows(_ nfts: [MyNfts]) {
        visibleRows = nfts
    }
}
