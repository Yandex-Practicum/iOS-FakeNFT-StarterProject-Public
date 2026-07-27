//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Сергей Петров on 16.07.2026.
//

import Foundation
import Observation
import os

// MARK: - ViewModel
@Observable
final class CartViewModel {
    
    // MARK: - Properties
    var items: [CartItem] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    private let networkClient: NetworkClient
    private let sortStorage = CartSortStorage()
    
    // MARK: - Init
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
        Task { await loadCart() }
    }
    
    // MARK: - Load Cart
    func loadCart() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let order = try await networkClient.send(
                request: GetOrderRequest(),
                type: OrderResponse.self
            )
            
            let nftIds = parseNftIds(from: order.nfts)
            
            var loadedItems: [CartItem] = []
            for nftId in nftIds {
                let nftData = try await networkClient.send(
                    request: GetNftRequest(nftId: nftId),
                    type: NftResponse.self
                )
                
                let cartItem = CartItem(
                    id: nftData.id,
                    imageURL: nftData.images.first ?? "",
                    name: nftData.name,
                    rating: nftData.rating,
                    price: nftData.price
                )
                loadedItems.append(cartItem)
            }
            
            self.items = loadedItems
            applyInitialSort()
            
        } catch {
            errorMessage = error.localizedDescription
            os_log(.error, log: .default, "Ошибка загрузки корзины: %{public}@", error.localizedDescription)
        }
        
        isLoading = false
    }
    
    // MARK: - Remove Item
    func removeItem(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
        
        Task { await syncOrderWithServer() }
    }
    
    // MARK: - Sync with Server
    private func syncOrderWithServer() async {
        let remainingNftIds = items.map { $0.id }
        
        do {
            _ = try await networkClient.send(
                request: UpdateOrderRequest(nftIds: remainingNftIds),
                type: OrderResponse.self
            )
            os_log(.info, log: .default, "Корзина успешно синхронизирована с сервером")
        } catch {
            os_log(.error, log: .default, "Ошибка синхронизации корзины: %{public}@", error.localizedDescription)
        }
    }
    
    // MARK: - Sort
    func sortItems(by sortType: CartSortType) {
        sortStorage.selectedSort = sortType
        
        switch sortType {
        case .price:
            items.sort { $0.price < $1.price }
        case .rating:
            items.sort { $0.rating > $1.rating }
        case .name:
            items.sort { $0.name < $1.name }
        }
    }
    
    private func applyInitialSort() {
        sortItems(by: sortStorage.selectedSort)
    }
    
    // MARK: - Computed Properties
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price }
    }
    
    // MARK: - Helpers
    private func parseNftIds(from rawIds: [String]) -> [String] {
        rawIds.flatMap { idString in
            idString.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        }
    }
}
