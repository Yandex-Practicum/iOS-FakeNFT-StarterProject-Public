import Foundation

typealias NftListCompletion = (Result<[Nft], Error>) -> Void

protocol NftService {
    func loadNfts(page: Int, size: Int, sortBy: String?, completion: @escaping NftListCompletion)
    func loadNft(id: String, completion: @escaping (Result<Nft, Error>) -> Void)
}

final class NftServiceImpl: NftService {
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }

    func loadNfts(page: Int, size: Int, sortBy: String?, completion: @escaping NftListCompletion) {
        let request = NftListRequest(dto: PageDto(page: page, size: size, sortBy: sortBy))
        client.send(request: request, type: [Nft].self, onResponse: completion)
    }

    func loadNft(id: String, completion: @escaping (Result<Nft, Error>) -> Void) {
        let request = NftByIdRequest(id: id)
        client.send(request: request, type: Nft.self, onResponse: completion)
    }
}
