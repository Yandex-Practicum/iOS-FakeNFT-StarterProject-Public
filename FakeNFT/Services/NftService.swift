import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func loadNftForCollection(id: String, completion: @escaping (Result<NftModel, Error>) -> Void)
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension NftServiceImpl {
    func loadNftForCollection(id: String, completion: @escaping (Result<NftModel, Error>) -> Void) {
//        if let nft = storage.getNft(with: id) {
//            completion(.success(nft))
//            return
//        }

        let request = NFTRequest(id: id)

        networkClient.send(
            request: request,
            type: NftResult.self,
            onResponse: { [weak self] (result: Result<NftResult, Error>)  in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    switch result {
                    case .success(let nftRes):
                        let nft = NftModel(
                            id: nftRes.id,
                            images: nftRes.images,
                            rating: nftRes.rating,
                            name: nftRes.name,
                            price: nftRes.price
                        )
                        print(nftRes)
                        completion(.success((nft)))
                    case .failure(let error):
                        completion(.failure((error)))
                    }
                }
            })
    }
}
