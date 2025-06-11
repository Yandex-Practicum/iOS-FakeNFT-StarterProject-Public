//
//  CartViewViewModel.swift
//  FakeNFT
//
//  Created by Max on 28.05.2025.
//

import SwiftUI

enum CartSortType: String, CaseIterable {
    case price = "По цене"
    case rating = "По рейтингу"
    case name = "По названию"
}

@MainActor
final class CartViewViewModel: ObservableObject {
    
    @AppStorage("selectedSortType") private var sortTypeStorage: String = CartSortType.name.rawValue
    
    // MARK: - Published Properties
    @Published var cartItems: [Nft] = []
    @Published var order: Order?
    @Published var currentSortType: CartSortType = .name
    @Published var state: LoadingState<[Nft]> = .loading
    
    
    // MARK: - Services
    private let nftService: NftCartService
    private let orderService: OrderService
    
    // MARK: - Computed Properties
    var totalAmount: Double {
        cartItems.reduce(0) { $0 + $1.price }
    }
    
    var nftCount: Int {
        cartItems.count
    }
    
    var isEmpty: Bool {
        cartItems.isEmpty
    }
    
    // MARK: - Initialization
    init(
        nftService: NftCartService = NftCartService.shared,
        orderService: OrderService = OrderService.shared
    ) {
        self.nftService = nftService
        self.orderService = orderService
        
        if let savedSort = CartSortType(rawValue: sortTypeStorage) {
            currentSortType = savedSort
        }
    }
    
    
    // MARK: - Cart Methods
    func sortItems(by sortType: CartSortType) {
        currentSortType = sortType
        sortTypeStorage = sortType.rawValue
        
        switch sortType {
        case .price:
            cartItems.sort { $0.price < $1.price }
        case .rating:
            cartItems.sort { $0.rating > $1.rating }
        case .name:
            cartItems.sort { $0.name < $1.name }
        }
        state = .loaded(cartItems)
    }
    
    func loadCart() async {
            state = .loading
            do {
                order = try await orderService.getOrder()
                let nftIds = order?.nfts ?? []
                cartItems = []
                
                for nftId in nftIds {
                    let nft = try await nftService.getNFT(id: nftId)
                    cartItems.append(nft)
                }
                
                // Синхронизируем enum с cartItems
                state = cartItems.isEmpty ? .empty : .loaded(cartItems)
                
            } catch {
                state = .error(error.localizedDescription)
                //cartItems = []  очищаем при ошибке
            }
        }
    
    
    func removeFromCart(_ nft: Nft) {
        cartItems.removeAll { $0.id == nft.id }
        // TODO: обновить заказ на сервере
    }
    
    func clearCart() {
        cartItems.removeAll()
        // TODO: очистить заказ на сервере
    }
}

