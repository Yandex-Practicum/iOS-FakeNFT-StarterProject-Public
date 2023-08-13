//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 13.08.2023.
//

import Foundation
import Combine

protocol LikesService {
    func fetchLikes() -> AnyPublisher<[Int], Error>
}

final class LikesServiceImpl: LikesService {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func fetchLikes() -> AnyPublisher<[Int], Error> {
        fetchProfile()
            .map { $0.likes }
            .map { $0.convertToInts() }
            .eraseToAnyPublisher()
    }

    private func fetchProfile() -> AnyPublisher<ProfileResult, Error> {
        let urlString = "https://64c516f8c853c26efada7af9.mockapi.io/api/v1/profile/1"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProfileResult.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
