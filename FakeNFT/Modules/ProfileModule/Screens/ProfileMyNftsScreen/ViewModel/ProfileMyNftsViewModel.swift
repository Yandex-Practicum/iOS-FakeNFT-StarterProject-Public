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
        nftsToLoad.forEach { id in
            dataStore.getItems(.myItems).compactMap({ $0 as? String }).contains(id) ? () : sendMyNftRequest(id)
        }
    }
    
    func setupSortDescriptor(_ descriptor: NftSortValue) {
        dataStore.nftSortDescriptor = descriptor
        updateVisibleRows(dataStore.getItems(.myItems).compactMap({ $0 as? MyNfts }))
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

// MARK: - Ext sendNftsRequest
private extension ProfileMyNftsViewModel {
    func sendMyNftRequest(_ id: String) {
        let request = RequestConstructor.constructSingleNftRequest(nftId: id)
        networkClient.networkPublisher(request: request, type: SingleNftModel.self)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.myNftError = error
                    self?.requestResult = nil
                }
            } receiveValue: { [weak self] singleNft in
                self?.loadNftAuthor(singleNft)
            }
            .store(in: &cancellables)
    }

    func loadNftAuthor(_ nft: SingleNftModel) {
        let request = RequestConstructor.constructCollectionAuthorRequest(for: nft.author)
        networkClient.networkPublisher(request: request, type: Author.self)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.myNftError = error

                }
            } receiveValue: { [weak self] author in
                self?.dataStore.addItem(self?.convert(nft, author: author))
                self?.requestResult = nil
            }
            .store(in: &cancellables)
    }
    
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
