//
//  OrderService.swift
//  FakeNFT
//
//  Created by Max on 05.06.2025.
//
import Foundation

final class OrderService {
    static let shared = OrderService()
    private let networkService: NetworkServiceProtocol
    private let orderEndpoint = "/api/v1/orders/1"
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    
    func getOrder() async throws -> Order {
        let data = try await networkService.performRequest(
            endpoint: orderEndpoint,
            method: NetworkConstants.HTTPMethod.get,
            body: nil,
            contentType: nil
        )
        return try JSONDecoder().decode(Order.self, from: data)
    }
    
    func updateOrder(nftIds: [String]) async throws -> Order {
        var components = URLComponents()
        components.queryItems = nftIds.map { URLQueryItem(name: "nfts", value: $0) }
        
        guard let bodyString = components.query,
              let bodyData = bodyString.data(using: .utf8) else {
            throw URLError(.badURL)
        }
        
        let data = try await networkService.performRequest(
            endpoint: orderEndpoint,
            method: NetworkConstants.HTTPMethod.put,
            body: bodyData,
            contentType: NetworkConstants.ContentType.formUrlEncoded
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
