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
    @Published var showDeleteConfirmation = false
    @Published var nftToDelete: Nft?
    @Published var isDeleting = false
    
    
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
            
            sortItems(by: currentSortType)
            
            state = cartItems.isEmpty ? .empty : .loaded(cartItems)
            
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func removeFromCart(_ nft: Nft) {
        Task {
            showDeleteConfirmation = false
            nftToDelete = nil
            isDeleting = true
            
            do {
                _ = try await orderService.removeFromOrder(nftId: nft.id)
                
                cartItems.removeAll { $0.id == nft.id }
                
                state = cartItems.isEmpty ? .empty : .loaded(cartItems)
                
            } catch {
                print("Ошибка при удалении NFT: \(error.localizedDescription)")
            }
            
            isDeleting = false
        }
    }
    
    func clearCart() async throws {
        do {
            _ = try await orderService.clearOrder()
            
            cartItems.removeAll()
            order = nil
            state = .empty
            
        } catch {
            throw error
        }
    }
    
    func clearCartOnServerOnly() async {
        do {
            _ = try await orderService.clearOrder()
            
        } catch {
            print("❌ Ошибка при очистке корзины на сервере: \(error)")
        }
    }
}


