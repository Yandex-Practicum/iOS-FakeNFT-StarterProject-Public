//
//  NftNetworkService.swift
//  FakeNFT
//
//  Created by MacBook on 01.09.2023.
//

class NftNetworkService: NftServiceProtocol {

    private let client = DefaultNetworkClient()

    func getNftList(nftIds: [Int], onCompletion: @escaping (Result<[NFTCard], Error>) -> Void) {
        var nfts: [NFTCard] = []
        let group = DispatchGroup()

        for nftId in nftIds {
            group.enter()
            getNft(nftId: nftId) { result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    onCompletion(.failure(error))
                    return
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            onCompletion(.success(nfts))
        }
    }

    func getNft(nftId: Int, onCompletion: @escaping (Result<NFTCard, Error>) -> Void) {
        let request = GetNftRequest(nftId: nftId)

        client.send(request: request, type: NFTCard.self, onResponse: onCompletion)
    }

}
