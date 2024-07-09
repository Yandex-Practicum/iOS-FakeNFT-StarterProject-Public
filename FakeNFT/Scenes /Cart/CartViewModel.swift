//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 25/06/2024.
//

import Combine
import Foundation

// MARK: - Enums

enum SortType: String {
    case price = "price"
    case rating = "rating"
    case name = "name"
}

// MARK: - ViewModel

final class CartViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var nftsInCart: [Nft] = []
    @Published var totalItems: String = "0 NFT"
    @Published var totalPrice: String = "0 ETH"
    @Published var isLoading: Bool = false
    
    private let unifiedService: NftServiceCombine
    private let sortKey = "selectedSortType"
    private var cancellables = Set<AnyCancellable>()
    
    let deleteButtonTapped = PassthroughSubject<Nft, Never>()
    let endRefreshingSubject = PassthroughSubject<Void, Never>()
    let presentDeleteConfirmationSubject = PassthroughSubject<(Nft, URL?), Never>()
    let confirmDeletionSubject = PassthroughSubject<Nft, Never>()
    
    // MARK: - Initialization
    
    init(unifiedService: NftServiceCombine) {
        self.unifiedService = unifiedService
        bindDeleteButtonTapped()
        bindConfirmDeletion()
        //        testAddOrder() // добвляем для тестирования
        loadCartItems()
        applySavedSortType()
    }
    
    // MARK: - Data Loading
    
    func loadCartItems(isPullToRefresh: Bool = false) {
        if !isPullToRefresh {
            isLoading = true
        }
        
        unifiedService.getCartItems()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if !isPullToRefresh {
                    self.isLoading = false
                }
                self.objectWillChange.send()
                if isPullToRefresh {
                    self.endRefreshingSubject.send()
                }
                switch completion {
                case .failure(let error):
                    print("Error loading cart items: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] items in
                guard let self = self else { return }
                self.nftsInCart = items
                self.updateCartSummary()
                self.applySavedSortType()
            })
            .store(in: &cancellables)
    }
    
    func removeItemFromCart(_ nft: Nft) {
        nftsInCart.removeAll { $0.id == nft.id }
        updateCartSummary()
        
        let nftIds = nftsInCart.map { $0.id }
        updateOrderOnServer(with: nftIds)
    }
    
    // MARK: - Sorting
    
    func sortCartItems(by sortType: SortType) {
        switch sortType {
        case .price:
            nftsInCart.sort { $0.price > $1.price }
        case .rating:
            nftsInCart.sort { $0.rating > $1.rating }
        case .name:
            nftsInCart.sort { $0.name < $1.name }
        }
        saveSortType(sortType)
        updateCartSummary()
    }
    
    // MARK: - Private Methods
    
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
    
    // метод для имитиции добавления нфт в корзину в каталоге
    private func testAddOrder() {
        let nftIds = [
            "5093c01d-e79e-4281-96f1-76db5880ba70",
            "d6a02bd1-1255-46cd-815b-656174c1d9c0",
            "594aaf01-5962-4ab7-a6b5-470ea37beb93",
            "eb959204-76cc-46ef-ba07-aefa036ca1a5",
            "739e293c-1067-43e5-8f1d-4377e744ddde",
            "3434c774-0e0f-476e-a314-24f4f0dfed86",
            "fa03574c-9067-45ad-9379-e3ed2d70df78",
            "a4edeccd-ad7c-4c7f-b09e-6edec02a812b"
        ]
        let orderId = "1"
        
        unifiedService.updateOrder(id: orderId, nftIds: nftIds)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error order creation: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { order in
                print("Order created: \(order)")
            })
            .store(in: &cancellables)
    }
    
    private func saveSortType(_ sortType: SortType) {
        UserDefaults.standard.set(sortType.rawValue, forKey: sortKey)
    }
    
    private func applySavedSortType() {
        if let savedSortType = UserDefaults.standard.string(forKey: sortKey),
           let sortType = SortType(rawValue: savedSortType) {
            sortCartItems(by: sortType)
        }
    }
    
    // MARK: - Update Methods
    
    private func updateOrderOnServer(with nftIds: [String]) {
        let orderId = "1"
        unifiedService.updateOrder(id: orderId, nftIds: nftIds)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    print("Error update order: \(error.localizedDescription)")
                case .finished:
                    break
                }
                self.updateUIAfterOrderUpdate()
            }, receiveValue: { order in
                print("Updated order: \(orderId) заказ: \(order)")
            })
            .store(in: &cancellables)
    }
    
    private func updateUIAfterOrderUpdate() {
        isLoading = false
        updateCartSummary()
        objectWillChange.send()
    }
    
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
