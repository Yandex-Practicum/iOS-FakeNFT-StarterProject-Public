//
// Created by Андрей Парамонов on 16.12.2023.
//

import UIKit

public final class StatisticsAssembly {
    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    public func build() -> UIViewController {
        let viewModel = StatisticsViewModelImpl(userService: servicesAssembler.userService,
                                                userDefaultsStore: servicesAssembler.userDefaultsStore)
        return StatisticsViewController(viewModel: viewModel)
    }
}
