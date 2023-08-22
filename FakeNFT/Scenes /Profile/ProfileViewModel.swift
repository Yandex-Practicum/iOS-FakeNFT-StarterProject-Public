import Foundation

protocol ProfileViewModelProtocol: AnyObject {
    var onChange: (() -> Void)? { get set }
    var onError: (() -> Void)? { get set }
    
    var nfts: [String]? { get }
    var error: Error? { get }
    var profile: ProfileModel? { get }
    
    func getProfileData()
    func isCheckConnectToInternet() -> Bool
}

final class ProfileViewModel: ProfileViewModelProtocol {
    var onChange: (() -> Void)?
    var onError: (() -> Void)?
    
    private var networkClient: NetworkClient
    private(set) var profile: ProfileModel? {
        didSet {
            onChange?()
        }
    }
    
    private(set) var nfts: [String]? {
        didSet {
            onChange?()
        }
    }
    
    private(set) var error: Error?
    
    init() {
        self.networkClient = DefaultNetworkClient()
    }
    
    func getProfileData() {
        networkClient.send(request: ProfileRequest(httpMethod: .get), type: ProfileModel.self) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                do {
                    self.profile = try result.get()
                } catch {
                    self.onError?()
                }
            }
        }
    }
    
    func isCheckConnectToInternet() -> Bool {
        InternetConnectionManager.isConnectedToNetwork()
    }
}

