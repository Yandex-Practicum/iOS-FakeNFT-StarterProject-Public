//
// Created by Андрей Парамонов on 14.12.2023.
//

import UIKit

protocol StatisticsViewModal {
    var numberOfRows: Int { get }
    func cellViewModel(for indexPath: IndexPath) -> StatisticsCellModel
    func didSelectRow(at indexPath: IndexPath)
    func viewWillAppear()

    var usersObservable: Observable<[User]> { get }
}

final class StatisticsViewModalImpl: StatisticsViewModal {
    private let userService: UserService

    @Observable
    private var users: [User] = []

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
        userService.loadUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users.sorted(by: Self.descRatingPredicate(lhs:rhs:))
                print(self?.users)
            case .failure(let error):
                print(error)
            }
        }
    }

    private static func descRatingPredicate(lhs: User, rhs: User) -> Bool {
        if let lhs = Double(lhs.rating), let rhs = Double(rhs.rating) {
            return lhs > rhs
        } else {
            return true // not sorted
        }
    }
}
