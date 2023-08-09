import Foundation

final class ProfileNetworkClient: ProfileNetworkClientProtocol {
    // MARK: - Public properties
    weak var presenter: ProfilePresenterNetworkProtocol?
    
    // MARK: - Private properties
    private let networkClient = DefaultNetworkClient()
    
    // MARK: - Public properties
    func getDecodedProfile(){
        networkClient.send(request: ProfileRequest(), type: ProfileResponseModel.self){ result in
            switch result {
            case .success(let model):
                self.presenter?.getProfile(with: model)
            case .failure(let error):
                print("\n\(error)")
            }
        }
    }
    
    func updateProfile(with data: ProfileResponseModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let updateRequest = ProfileUpdateRequest(updatedData: data)
        
        networkClient.send(request: updateRequest) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


struct  ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        return URL(string: ProfileConstants.endpoint + ProfileConstants.apiV1Profile1Get)
    }
}

struct ProfileUpdateRequest: NetworkRequest {
    var endpoint: URL? {
        return URL(string: ProfileConstants.endpoint + ProfileConstants.apiV1Profile1Get)
    }
    var httpMethod: HttpMethod {
        return .put
    }
    var dto: Encodable?
    init(updatedData: ProfileResponseModel) {
        self.dto = updatedData
    }
}
