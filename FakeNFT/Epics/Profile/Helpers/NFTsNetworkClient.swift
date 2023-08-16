import Foundation

protocol NFTsNetworkClientProtocol {
    func getNFTBy(id: String, completion: @escaping (Result<NFTResponseModel, Error>) -> Void)
    func getAuthorOfNFC(by id: String, completion: @escaping (Result<AuthorResponseModel, Error>) -> Void)
}

final class NFTsNetworkClient: NFTsNetworkClientProtocol {
    // MARK: - Private properties
    private let networkClient = DefaultNetworkClient()
    
    func getNFTBy(id: String, completion: @escaping (Result<NFTResponseModel, Error>) -> Void) {
        networkClient.send( request: NftByIdRequest(id: id), type: NFTResponseModel.self) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAuthorOfNFC(by id: String, completion: @escaping (Result<AuthorResponseModel, Error>) -> Void) {
        networkClient.send(request: AuthorByIdRequest(id: id), type: AuthorResponseModel.self) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct AuthorByIdRequest: NetworkRequest {
    private let id: String
    init(id: String) {
        self.id = id
    }
    
    var endpoint: URL? {
        return URL(string: ProfileConstants.endpoint + ProfileConstants.apiV1UsersUserIdGet + id)
    }
}

struct  NftByIdRequest: NetworkRequest {
    private let id: String
    init(id: String) {
        self.id = id
    }
    
    var endpoint: URL? {
        return URL(string: ProfileConstants.endpoint + ProfileConstants.apiV1NftNftIdGet + id)
    }
}
