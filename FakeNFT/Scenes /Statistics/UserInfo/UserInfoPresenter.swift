import Foundation

// MARK: - Protocol

protocol UserInfoPresenterProtocol {
    var user: UserInfo? { get set }
    func viewDidLoad()
}

// MARK: - State

enum UserInfoState {
    case initial, loading, data(UserInfo), failed(Error)
}

final class UserInfoPresenter: UserInfoPresenterProtocol {
    
    // MARK: - Properties
    weak var view: UserInfoViewProtocol?
    var user: UserInfo?
    
    private let userID: String
    private let service: UserInfoServiceProtocol
    private var state = UserInfoState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init
    init(userID: String, service: UserInfoServiceProtocol) {
        self.userID = userID
        self.service = service
    }
    
    // MARK: - Functions
    func viewDidLoad() {
        state = .loading
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoadingAndBlockUI()
            loadUserInfo()
        case .data(let user):
            view?.hideLoadingAndUnblockUI()
            self.user = user
            view?.displayUserInfo(with: user)
        case .failed(let error):
            view?.hideLoadingAndUnblockUI()
            let errorModel = makeErrorModel(error)
            view?.showError(errorModel)
        }
    }
    
    private func loadUserInfo() {
        service.loadUserInfo(with: userID) { [weak self] result in
            switch result {
            case .success(let user):
                self?.state = .data(user)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }

        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}
