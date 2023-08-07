import Foundation

protocol ProfileNetworkClientProtocol: AnyObject {
    func getDecodedProfile()
}

struct  ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        return URL(string: ProfileConstants.endpoint + ProfileConstants.apiV1Profile1Get)
    }
}

final class ProfileNetworkClient: ProfileNetworkClientProtocol {
    private let networkClient = DefaultNetworkClient()
    
    weak var presenter: ProfilePresenterNetworkProtocol?
    
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
