//
//  OrderService.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 13.08.2023.
//

import Foundation
import Combine

protocol StatisticsOrderService {
    func fetchOrder() -> AnyPublisher<[Int], Error>
}

final class OrderServiceImpl: StatisticsOrderService {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func fetchOrder() -> AnyPublisher<[Int], Error> {
        fetchOrder()
            .map { $0.nfts }
            .map { $0.convertToInts() }
            .eraseToAnyPublisher()
    }

    private func fetchOrder() -> AnyPublisher<OrderResult, Error> {
        let urlString = "https://64c516f8c853c26efada7af9.mockapi.io/api/v1/orders/1"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: OrderResult.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
