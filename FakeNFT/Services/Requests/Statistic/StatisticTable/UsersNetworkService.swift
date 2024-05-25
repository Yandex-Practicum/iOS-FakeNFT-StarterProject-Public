import Foundation

typealias UsersCompletion = (Result<[UsersModel], Error>) -> Void

protocol UsersService {
    func loadNft(completion: @escaping UsersCompletion)
}

final class UsersServiceImpl: UsersService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadNft(completion: @escaping UsersCompletion) {

        let request = UsersRequest()
        networkClient
            .send(
                request: request,
                type: [UsersModel].self
            ) { result in
                switch result {
                case .success(let users):
                    completion(.success(users))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}
