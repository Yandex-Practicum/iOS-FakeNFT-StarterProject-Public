import Foundation

// MARK: - Protocol

protocol StatisticsPresenterProtocol {
    func viewDidLoad()
    func showSortingMenu()
}

// MARK: - State

enum UsersState {
    case initial, loading, data([User]), update, failed(Error)
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    
    // MARK: - Properties
    weak var view: StatisticsViewProtocol?
    
    private var userCellModels = [UserCellModel]()
    
    private let userDefaults = UserDefaults.standard
    
    private var sorting: Sortings? {
        get {
            guard let sortingRawValue = userDefaults.string(forKey: "Statistics Sorting") else {
                return nil
            }
            return Sortings(rawValue: sortingRawValue)
        }
        set {
            userDefaults.set(newValue?.rawValue, forKey: "Statistics Sorting")
        }
    }
    
    private let service: UsersServiceProtocol
    private var state = UsersState.initial {
        didSet {
            stateDidChanged()
        }
    }

    // MARK: - Init

    init(service: UsersServiceProtocol) {
        self.service = service
    }

    // MARK: - Functions

    func viewDidLoad() {
        state = .loading
    }
    
    func showSortingMenu() {
        let sortingMenu = makeSortingMenu()
        view?.showSortingMenu(sortingMenu)
    }
    
    private func makeSortingMenu() -> SortingModel {
        return SortingModel { [weak self] selectSorting in
            self?.setSorting(selectSorting)
        }
    }
    
    private func setSorting(_ selectSorting: Sortings?) {
        sorting = selectSorting
        state = .update
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoadingAndBlockUI()
            loadUsers()
        case .data(let users):
            view?.hideLoadingAndUnblockUI()
            userCellModels = setRatingPositionsToUsers(users)
            state = .update
        case .update:
            let cellModels = sorting(users: userCellModels, with: sorting)
            view?.displayCells(cellModels)
        case .failed(let error):
            view?.hideLoadingAndUnblockUI()
            let errorModel = makeErrorModel(error)
            view?.showError(errorModel)
        }
    }
    
    private func loadUsers() {
        service.loadUsers() { [weak self] result in
            switch result {
            case .success(let users):
                self?.state = .data(users)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    private func setRatingPositionsToUsers(_ users: [User]) -> [UserCellModel] {
        
        let sortedUsers = users.sorted { (lhs: User, rhs: User) -> Bool in
            return lhs.ratingValue > rhs.ratingValue
        }
        
        let setRatingPositions = sortedUsers.enumerated().map { (index, user) in
            let updateUser = UserCellModel(
                id: user.id,
                name: user.name,
                avatar: user.avatar,
                nfts: user.nfts,
                ratingValue: user.ratingValue,
                ratingPosition: index + 1)
            return updateUser
        }
        
       return setRatingPositions
    }
    
    private func sorting(users: [UserCellModel], with sorting: Sortings?) -> [UserCellModel] {
        switch sorting {
        case .byName:
            return sortingByName(users)
        case .byRating:
            return sortingByRating(users)
        case .none:
            return users
        }
    }
    
    private func sortingByName(_ users: [UserCellModel]) -> [UserCellModel] {
        let sortedUsers = users.sorted { (lhs: UserCellModel, rhs: UserCellModel) -> Bool in
            return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
        }
        return sortedUsers
    }
    
    private func sortingByRating(_ users: [UserCellModel]) -> [UserCellModel] {
        let sortedUsers = users.sorted { (lhs: UserCellModel, rhs: UserCellModel) -> Bool in
            return lhs.ratingPosition < rhs.ratingPosition
        }
        return sortedUsers
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
