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
    private var errorIsTriggered: Bool = false
    
    private let networkClient: NetworkClient
    private let nftsToLoad: [String]
    private let dataStore: DataStorageManagerProtocol
    
    init(networkClient: NetworkClient,  nftsToLoad: [String], dataStore: DataStorageManagerProtocol) {
        self.networkClient = networkClient
        self.nftsToLoad = nftsToLoad
        self.dataStore = dataStore
        bind()
    }
    
    func load() {
        requestResult = .loading
        errorIsTriggered = false
        
        nftsToLoad.forEach { id in
            guard !isStoredInMyNfts(id),
                  let nft = getNftForId(id)
            else {
                requestResult = nil
                return
            }
            
            let request = RequestConstructor.constructCollectionAuthorRequest(for: nft.author)
            networkClient.networkPublisher(request: request, type: Author.self)
                .receive(on: DispatchQueue.main)
                .delay(for: 1, scheduler: RunLoop.main)
                .sink { [weak self] completion in
                    guard let self else { return }
                    if case .failure(let error) = completion, !self.errorIsTriggered {
                        self.errorIsTriggered = true
                        self.myNftError = error
                    }
                    self.requestResult = nil
                } receiveValue: { [weak self] author in
                    self?.dataStore.addItem(self?.convert(nft, author: author))
                    self?.requestResult = nil
                }
                .store(in: &cancellables)
        }
        
    }
    
    func setupSortDescriptor(_ descriptor: NftSortValue) {
        dataStore.nftSortDescriptor = descriptor
        updateVisibleRows(getItems())
    }
    
    private func getItems() -> [MyNfts] {
        return dataStore.getItems(.myItems).compactMap({ $0 as? MyNfts })
    }
}

// MARK: - Ext Bind
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

// MARK: - Ext convert
private extension ProfileMyNftsViewModel {
    func convert(_ nft: SingleNftModel, author: Author) -> MyNfts {
        return MyNfts(
            name: nft.name,
            images: nft.images,
            rating: nft.rating,
            price: nft.price,
            author: author.name,
            id: nft.id)
    }
}

// MARK: - Ext checking
private extension ProfileMyNftsViewModel {
    func isStoredInMyNfts(_ id: String) -> Bool {
        return dataStore.getItems(.myItems)
            .compactMap({ ($0 as? MyNfts)?.id })
            .contains(id)
    }
    
    func getNftForId(_ id: String) -> SingleNftModel? {
        return dataStore.getItems(.singleNftItems)
            .compactMap({ $0 as? SingleNftModel })
            .first(where: { $0.id == id })
    }
}
