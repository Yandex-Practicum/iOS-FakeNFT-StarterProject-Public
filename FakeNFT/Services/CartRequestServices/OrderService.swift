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
    

    func getOrder() async throws -> Order {
        let data = try await networkService.performRequest(endpoint: "/api/v1/orders/1")
        return try JSONDecoder().decode(Order.self, from: data)
    }
    
    func updateOrder(nftIds: [String]) async throws -> Order {
        var components = URLComponents()
        components.queryItems = nftIds.map { URLQueryItem(name: "nfts", value: $0) }
        
        guard let bodyString = components.query else {
            throw URLError(.badURL)
        }
        
        let bodyData = bodyString.data(using: .utf8)!
        
        let data = try await networkService.performRequest(
            endpoint: "/api/v1/orders/1",
            method: "PUT",
            body: bodyData,
            contentType: "application/x-www-form-urlencoded"
        )
        
        let updatedOrder = try JSONDecoder().decode(Order.self, from: data)
        
        return updatedOrder
    }
    
    func removeFromOrder(nftId: String) async throws -> Order {
 
        let currentOrder = try await getOrder()
      
        var updatedNfts = currentOrder.nfts
        updatedNfts.removeAll { $0 == nftId }
   
        return try await updateOrder(nftIds: updatedNfts)
    }
    
    func clearOrder() async throws -> Order {
        return try await updateOrder(nftIds: [])
    }
}
