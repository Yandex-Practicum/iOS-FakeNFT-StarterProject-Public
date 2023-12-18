//
// Created by Андрей Парамонов on 17.12.2023.
//

import Foundation

final class UserDefaultsStore {
    private let userDefaults = UserDefaults.standard
    private let statisticsSortType = "sortTypeStore"

    static let shared = UserDefaultsStore()

    private init() {}

    func getStatisticsSortType() -> StatisticsSortType {
        let value = userDefaults.integer(forKey: statisticsSortType)
        return StatisticsSortType(rawValue: value) ?? .none
    }

    func setStatisticsSortType(_ sortType: StatisticsSortType) {
        userDefaults.set(sortType.rawValue, forKey: statisticsSortType)
    }
}
