//
// Created by Андрей Парамонов on 14.12.2023.
//

import Foundation

protocol StatisticsViewModel {
    var numberOfRows: Int { get }
    var usersObservable: Observable<[User]> { get }
    var isLoadingObservable: Observable<Bool> { get }
    var isRefreshingObservable: Observable<Bool> { get }

    func itemModel(for indexPath: IndexPath) -> StatisticsCellModel
    func didSelectModel(at indexPath: IndexPath)
    func viewDidLoad()
    func sortBy(_ sortType: StatisticsSortType)
    func didTriggerRefreshAction()
}

final class StatisticsViewModelImpl: StatisticsViewModel {
    private let userService: UserService
    private let userDefaultsStore: UserDefaultsStore

    @Observable
    private var users: [User] = []

    private var currentSortType: StatisticsSortType {
        didSet {
            userDefaultsStore.setStatisticsSortType(currentSortType)
        }
    }

    @Observable
    private var isLoading: Bool = false
    @Observable
    private var isRefreshing: Bool = false

    var usersObservable: Observable<[User]> {
        $users
    }

    init(userService: UserService, userDefaultsStore: UserDefaultsStore) {
        self.userService = userService
        self.userDefaultsStore = userDefaultsStore
        currentSortType = userDefaultsStore.getStatisticsSortType()
    }

    var numberOfRows: Int {
        users.count
    }

    var isLoadingObservable: Observable<Bool> {
        $isLoading
    }

    var isRefreshingObservable: Observable<Bool> {
        $isRefreshing
    }

    func itemModel(for indexPath: IndexPath) -> StatisticsCellModel {
        let user = users[indexPath.row]
        return StatisticsCellModel(rating: indexPath.row + 1,
                                   name: user.name,
                                   nftCount: user.nfts.count,
                                   photoURL: user.avatar)
    }

    func didSelectModel(at indexPath: IndexPath) {
        print("didSelectRow")
    }

    func viewDidLoad() {
        isLoading = true
        loadUsers()
    }

    private func loadUsers() {
        userService.loadUsers { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let users):
                self.users = self.sortUsers(users, sortType: self.currentSortType)
            case .failure(let error):
                print(error)
            }
            if self.isLoading {
                self.isLoading = false
            }
            if self.isRefreshing {
                self.isRefreshing = false
            }
        }
    }

    func sortBy(_ sortType: StatisticsSortType) {
        if currentSortType == sortType {
            return
        }
        users = sortUsers(users, sortType: sortType)
        currentSortType = sortType
    }

    private func sortUsers(_ users: [User], sortType: StatisticsSortType) -> [User] {
        let result: [User]
        switch sortType {
        case .name:
            result = users.sorted(by: Self.ascNamePredicate(lhs:rhs:))
        case .rating:
            result = users.sorted(by: Self.descRatingPredicate(lhs:rhs:))
        case .none:
            result = users
        }
        print(result)
        return result
    }

    private static func descRatingPredicate(lhs: User, rhs: User) -> Bool {
        if let lhs = Double(lhs.rating), let rhs = Double(rhs.rating) {
            return lhs > rhs
        } else {
            return true // not sorted
        }
    }

    private static func ascNamePredicate(lhs: User, rhs: User) -> Bool {
        lhs.name < rhs.name
    }

    func didTriggerRefreshAction() {
        isRefreshing = true
        loadUsers()
    }
}
