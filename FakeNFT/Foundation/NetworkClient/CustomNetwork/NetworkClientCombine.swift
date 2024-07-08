//
//  NetworkClientCombine.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 07/07/2024.
//

import Foundation
import Combine

class NetworkClientCombine {
    private let baseClient: DefaultNetworkClient

    init(baseClient: DefaultNetworkClient = DefaultNetworkClient()) {
        self.baseClient = baseClient
    }

    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type
    ) -> AnyPublisher<T, NetworkClientError> {
        return Future<T, NetworkClientError> { promise in
            self.baseClient.send(
                request: request,
                type: type,
                completionQueue: .main
            ) { result in
                switch result {
                case .success(let response):
                    print("Request succeeded: \(response)")
                    promise(.success(response))
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    if let networkError = error as? NetworkClientError {
                        promise(.failure(networkError))
                    } else {
                        promise(.failure(.urlSessionError))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
