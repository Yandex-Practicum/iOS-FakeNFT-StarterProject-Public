import Foundation

protocol StatisticPresenterProtocol {
    
    var currentSortType: StatisticPresenter.SortType { get }
    
    func viewDidLoad()
    func didSelectSortOption(_ type: StatisticPresenter.SortType)
    func didSelectUser(at index: Int)
    func numberOfUsers() -> Int
    func user(at index: Int) -> User
    func getPlace(for index: Int) -> Int
}

protocol StatisticViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(message: String, retryAction: @escaping () -> Void)
    func showSortOptions(currentSort: StatisticPresenter.SortType)
}

final class StatisticPresenter: StatisticPresenterProtocol {
    
    weak var view: StatisticViewProtocol?
    var currentSortType: SortType {
        return sortType
    }
    private let usersService: UsersService
    private var users: [User] = []
    private var sortType: SortType = .rating
    
    init(usersService: UsersService) {
        self.usersService = usersService
        loadSortType()
    }
    
    func viewDidLoad() {
        loadUsers()
    }
    
    private func loadUsers() {
        view?.showLoading()
        
        usersService.loadUsers(page: 0, size: 50) { [weak self] result in
            guard let self = self else { return }
            
            self.view?.hideLoading()
            
            switch result {
            case .success(let users):
                self.users = users
                self.sortUsers()
                self.view?.reloadData()
                
            case .failure(let error):
                print("Error loading users: \(error)")
                let retryAction = { self.loadUsers() }
                self.view?.showError(
                    message: "Не удалось загрузить пользователей",
                    retryAction: retryAction
                )
            }
        }
    }
    
    private func loadSortType() {
        if let savedSortType = UserDefaults.standard.string(forKey: "statisticSortType"),
           let type = SortType(rawValue: savedSortType) {
            sortType = type
        }
    }
    
    private func saveSortType() {
        UserDefaults.standard.set(sortType.rawValue, forKey: "statisticSortType")
    }
    
    private func sortUsers() {
        switch sortType {
        case .rating:
            users.sort { (Int($0.rating) ?? 0) > (Int($1.rating) ?? 0) }
        case .name:
            users.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }
    
    // MARK: - Public Methods
    
    func didSelectSortOption(_ type: SortType) {
        sortType = type
        saveSortType()
        sortUsers()
        view?.reloadData()
    }
    
    func didSelectUser(at index: Int) {
        guard index < users.count else { return }
        let user = users[index]
        // Здесь будет переход к профилю пользователя
        print("Selected user: \(user.name)")
    }
    
    func numberOfUsers() -> Int {
        return users.count
    }
    
    func user(at index: Int) -> User {
        return users[index]
    }
    
    func getPlace(for index: Int) -> Int {
        return index + 1
    }
    
    // MARK: - SortType Enum
    
    enum SortType: String, CaseIterable {
        case rating = "rating"
        case name = "name"
        
        var displayName: String {
            switch self {
            case .rating: return "По рейтингу"
            case .name: return "По имени"
            }
        }
    }
}
