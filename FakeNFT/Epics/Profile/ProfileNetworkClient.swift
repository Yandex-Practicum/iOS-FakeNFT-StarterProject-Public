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
        networkClient.send(request: ProfileRequest(), type: ProfileModel.self){ result in
            switch result {
            case .success(let model):
                print("\n\(model)")
                self.presenter?.getData(for: model)
            case .failure(let error):
                print("\n\(error)")
            }
        }
    }
    
    func getProfile() {
        networkClient.send(request: ProfileRequest()){ result in
            switch result {
            case .success(let data):
                print("\n\(data)")
            case .failure(let error):
                print("\n\(error)")
            }
        }
    }
}
