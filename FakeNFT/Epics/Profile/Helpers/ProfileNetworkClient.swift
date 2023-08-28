import Foundation

final class ProfileNetworkClient: ProfileNetworkClientProtocol {
    // MARK: - Public properties
    
    weak var presenter: ProfilePresenterNetworkProtocol?
    
    // MARK: - Private properties
    
    private let networkClient = DefaultNetworkClient()
    
    // MARK: - Public properties
    
    func getDecodedProfile(){
        networkClient.send(request: UserProfileRequest(), type: ProfileResponseModel.self){ result in
            switch result {
            case .success(let model):
                self.presenter?.getProfile(with: model)
            case .failure(let error):
                self.presenter?.showAlert(with: error)
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
