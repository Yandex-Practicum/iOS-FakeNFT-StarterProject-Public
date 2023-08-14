import Foundation

protocol MyNFTsNetworkClientProtocol {
    var presenter: MyNFTsPresenterProtocol? { get set }
    func getNFTBy(id: String)
    func getAuthorOfNFC(by id: String)
}

final class MyNFTsNetworkClient: MyNFTsNetworkClientProtocol {
    // MARK: - Public properties
    var presenter: MyNFTsPresenterProtocol?
    private let dataLoadingQueue = DispatchQueue(label: "dataLoadingQueue", qos: .userInteractive)
    
    // MARK: - Private properties
    private let networkClient = DefaultNetworkClient()
    func getNFTBy(id: String) {
        networkClient.send( request: NftByIdRequest(id: id), type: NFTResponseModel.self) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async{
                    self.presenter?.addNFTAuthor(with: model.id)
                }
            case .failure(let error):
                DispatchQueue.main.async{
                    print("\n❌ \(error)")
                }
            }
        }
    }
    
    func getAuthorOfNFC(by id: String) {
        networkClient.send(request: AuthorByIdRequest(id: id), type: AuthorResponseModel.self) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async{
                    print("\n✅🟢\n\(model)")
                }
            case .failure(let error):
                DispatchQueue.main.async{
                    print("\n❌❌ \(error)")
                }
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
