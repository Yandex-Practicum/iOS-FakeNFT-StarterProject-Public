//
//  OrderService.swift
//  FakeNFT
//
//  Created by Max on 05.06.2025.
//
import Foundation

class OrderService {
    static let shared = OrderService()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    /// Получить заказ (корзину) пользователя
    func getOrder() async throws -> Order {
        let data = try await networkService.performRequest(endpoint: "/api/v1/orders/1")
        return try JSONDecoder().decode(Order.self, from: data)
    }
    
    /// Добавить NFT в заказ (если API поддерживает)
    func addToOrder(nftId: String) async throws -> Order {
        // TODO: PUT запрос для добавления
        throw URLError(.badURL)
    }
}
