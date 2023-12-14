//
// Created by Андрей Парамонов on 14.12.2023.
//

import UIKit

protocol StatisticsViewModelProtocol {
    var numberOfRows: Int { get }
    func cellViewModel(for indexPath: IndexPath) -> StatisticsCellModel
    func didSelectRow(at indexPath: IndexPath)
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
    var numberOfRows: Int {
        10
    }

    func cellViewModel(for indexPath: IndexPath) -> StatisticsCellModel {
        StatisticsCellModel(rating: "1",
                            name: "Andrey",
                            nftCount: "10",
                            photoURL: URL(string: "https://picsum.photos/200")!)
    }

    func didSelectRow(at indexPath: IndexPath) {
        print("didSelectRow")
    }
}
