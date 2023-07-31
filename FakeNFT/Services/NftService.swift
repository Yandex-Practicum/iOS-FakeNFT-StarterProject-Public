import Foundation

protocol NftService {
  func loadNft(id: String, completion: @escaping (Result<Nft, Error>) -> Void)
}

final class NftServiceImpl: NftService {

  private let networkClient: NetworkClient

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  func loadNft(id: String, completion: @escaping (Result<Nft, Error>) -> Void) {
    let request = NFTRequest(id: id)
    networkClient.send(request: request, type: Nft.self) { result in
      switch result {
      case .success(let nft):
        completion(.success(nft))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
