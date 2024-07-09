//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 25/06/2024.
//

import Combine
import Foundation

final class CartViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var nftsInCart: [Nft] = []
    @Published var totalItems: String = "0 NFT"
    @Published var totalPrice: String = "0 ETH"
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    let deleteButtonTapped = PassthroughSubject<Nft, Never>()
    let endRefreshingSubject = PassthroughSubject<Void, Never>()
    let presentDeleteConfirmationSubject = PassthroughSubject<(Nft, URL?), Never>()
    let confirmDeletionSubject = PassthroughSubject<Nft, Never>()
    
    // MARK: - Initialization
    
    init() {
        bindDeleteButtonTapped()
        bindConfirmDeletion()
        loadMockData()
    }
    
    
    func removeItemFromCart(_ nft: Nft) {
        nftsInCart.removeAll { $0.id == nft.id }
        let nftIds = nftsInCart.map { $0.id }
        updateCartSummary()
    }
    
    private func bindDeleteButtonTapped() {
        deleteButtonTapped
            .sink { [weak self] nft in
                self?.presentDeleteConfirmation(for: nft)
            }
            .store(in: &cancellables)
    }
    
    private func bindConfirmDeletion() {
        confirmDeletionSubject
            .sink { [weak self] nft in
                self?.removeItemFromCart(nft)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Data Loading
    
    func loadMockData(isPullToRefresh: Bool = false) {
        if !isPullToRefresh {
            isLoading = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.nftsInCart = MockData.createMockNFTs()
            self?.updateCartSummary()
            self?.isLoading = false
            self?.objectWillChange.send()
        }
    }
    
    // MARK: - Update Methods
    
    private func updateCartSummary() {
        totalItems = "\(nftsInCart.count) NFT"
        let totalPriceValue = nftsInCart.reduce(0) { $0 + $1.price }
        totalPrice = String(format: "%.2f ETH", totalPriceValue)
    }
    
    private func presentDeleteConfirmation(for nft: Nft) {
        let url = nft.images.first
        presentDeleteConfirmationSubject.send((nft, url))
    }
    
}
