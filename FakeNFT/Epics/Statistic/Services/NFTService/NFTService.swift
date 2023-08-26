//
//  NFTService.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 13.08.2023.
//

import Foundation
import Combine

protocol NFTSService {
    func fetchNFTS(numbers: [Int]) -> AnyPublisher<[NFT], Error>
}

final class NFTSServiceImpl: NFTSService {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func fetchNFTS(numbers: [Int]) -> AnyPublisher<[NFT], Error> {
        Publishers.Sequence(sequence: numbers)
            .flatMap { self.fetchNFT(withNumber: $0) }
            .map { $0.toNFT() }
            .collect()
            .eraseToAnyPublisher()
    }

    private func fetchNFT(withNumber number: Int) -> AnyPublisher<NFTResult, Error> {
        let urlString = "https://64c516f8c853c26efada7af9.mockapi.io/api/v1/nft/\(number)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: NFTResult.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
