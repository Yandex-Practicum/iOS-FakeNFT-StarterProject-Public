//
// Created by Андрей Парамонов on 14.12.2023.
//

import UIKit

enum StatisticsSortType: String {
    case none, name, rating
}

protocol StatisticsViewModel {
    var numberOfRows: Int { get }
    var usersObservable: Observable<[User]> { get }

    func cellViewModel(for indexPath: IndexPath) -> StatisticsCellModel
    func didSelectRow(at indexPath: IndexPath)
    func viewWillAppear()
    func sortBy(_ sortType: StatisticsSortType)
    func refreshControlPulled()
}

final class StatisticsViewModelImpl: StatisticsViewModel {
    private let userService: UserService

    @Observable
    private var users: [User] = []
    private var currentSortType: StatisticsSortType = .none

    var usersObservable: Observable<[User]> {
        $users
    }

    init(userService: UserService) {
        self.userService = userService
    }

    var numberOfRows: Int {
        users.count
    }

    func cellViewModel(for indexPath: IndexPath) -> StatisticsCellModel {
        let user = users[indexPath.row]
        return StatisticsCellModel(rating: indexPath.row + 1,
                                   name: user.name,
                                   nftCount: user.nfts.count,
                                   photoURL: user.avatar)
    }

    func didSelectRow(at indexPath: IndexPath) {
        print("didSelectRow")
    }

    func viewWillAppear() {
        loadUsers()
    }

    private func loadUsers() {
        userService.loadUsers { [weak self] result in
            switch result {
            case .success(let users):
                guard let self else { return }
                self.users = users.sorted(by: Self.descRatingPredicate(lhs:rhs:))
                self.sortUsers(self.currentSortType)
            case .failure(let error):
                print(error)
            }
        }
    }

    func sortBy(_ sortType: StatisticsSortType) {
        if currentSortType == sortType {
            return
        }
        sortUsers(sortType)
        currentSortType = sortType
    }

    private func sortUsers(_ sortType: StatisticsSortType) {
        switch sortType {
        case .name:
            users = users.sorted(by: Self.ascNamePredicate(lhs:rhs:))
        case .rating:
            users = users.sorted(by: Self.descRatingPredicate(lhs:rhs:))
        default:
            break
        }
        print(users)
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

    func refreshControlPulled() {
        loadUsers()
    }
}
