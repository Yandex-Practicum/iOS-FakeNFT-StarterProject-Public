import Foundation

final class NftListNetworkService: NftListService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadNfts(ids: [String], completion: @escaping (Result<[Nft], Error>) -> Void) {
        guard !ids.isEmpty else {
            completion(.success([]))
            return
        }

        let group = DispatchGroup()
        var result = Array<Nft?>(repeating: nil, count: ids.count)
        var firstError: Error?

        for (index, id) in ids.enumerated() {
            group.enter()
            let request = NFTRequest(id: id)

            networkClient.send(
                request: request,
                type: Nft.self,
                completionQueue: .global(qos: .userInitiated)
            ) { res in
                defer { group.leave() }
                switch res {
                case .success(let nft):
                    result[index] = nft
                case .failure(let error):
                    if firstError == nil { firstError = error }
                }
            }
        }

        group.notify(queue: .global(qos: .userInitiated)) {
            if let error = firstError {
                completion(.failure(error))
            } else {
                completion(.success(result.compactMap { $0 }))
            }
        }
    }
}

