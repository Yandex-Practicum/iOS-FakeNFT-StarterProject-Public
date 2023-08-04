//
//  PublishersFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 04.08.2023.
//

import Foundation
import Combine

protocol PublishersFactoryProtocol {
    func getNftsPublisher(_ ids: [String]) -> AnyPublisher<[SingleNftModel], NetworkError>
    func getMyNftsPublisher(_ ids: [String]) -> AnyPublisher<[MyNfts], NetworkError>
    func getProfilePublisher() -> AnyPublisher<Profile, NetworkError>
}

final class PublishersFactory {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
}

// MARK: - Ext PublishersFactoryProtocol
extension PublishersFactory: PublishersFactoryProtocol {
    func getMyNftsPublisher(_ ids: [String]) -> AnyPublisher<[MyNfts], NetworkError> {
        getNftsPublisher(ids)
            .flatMap { [weak self] nfts in
                guard let self else {
                    return Empty<[MyNfts], NetworkError>().eraseToAnyPublisher()
                }
                return self.getMyNftsPublisher(nfts)
            }
            .eraseToAnyPublisher()
    }
    
    func getNftsPublisher(_ ids: [String]) -> AnyPublisher<[SingleNftModel], NetworkError> {
        ids.publisher
            .setFailureType(to: NetworkError.self)
            .flatMap({ self.getNftPublisher($0) })
            .collect()
            .eraseToAnyPublisher()
    }
    
    func getProfilePublisher() -> AnyPublisher<Profile, NetworkError> {
        let request = RequestConstructor.constructProfileRequest()
        return networkClient.networkPublisher(request: request, type: Profile.self)
    }
}

// MARK: - Ext Private
private extension PublishersFactory {
    func getNftPublisher(_ id: String) -> AnyPublisher<SingleNftModel, NetworkError> {
        let request = RequestConstructor.constructSingleNftRequest(nftId: id)
        return networkClient.networkPublisher(request: request, type: SingleNftModel.self)
    }
    
    func getMyNftsPublisher(_ nfts: [SingleNftModel]) -> AnyPublisher<[MyNfts], NetworkError> {
        nfts.publisher
            .setFailureType(to: NetworkError.self)
            .flatMap({ self.getMyNftPublisher($0) })
            .collect()
            .eraseToAnyPublisher()
    }
    
    func getMyNftPublisher(_ nft: SingleNftModel) -> AnyPublisher<MyNfts, NetworkError> {
        let request = RequestConstructor.constructCollectionAuthorRequest(for: nft.author)
        return networkClient.networkPublisher(request: request, type: Author.self)
            .delay(for: 5, scheduler: RunLoop.main)
            .mapError({ networkError in
                return NetworkError.invalidResponse
            })
            .map { author in
                return self.convert(nft, author: author.name)
            }
            .eraseToAnyPublisher()
    }
    
    func convert(_ nft: SingleNftModel, author: String) -> MyNfts {
        return MyNfts(
            name: nft.name,
            images: nft.images,
            rating: nft.rating,
            price: nft.price,
            author: author,
            id: nft.id)
    }
}
