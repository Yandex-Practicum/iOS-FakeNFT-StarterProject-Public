import Foundation

struct  ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        return URL(string: ProfileConstants.endpoint + ProfileConstants.apiV1Profile1Get)
    }
}

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
                self.presenter?.getData(for: model)
            case .failure(let error):
                print("\n\(error)")
            }
        }
    }
}
