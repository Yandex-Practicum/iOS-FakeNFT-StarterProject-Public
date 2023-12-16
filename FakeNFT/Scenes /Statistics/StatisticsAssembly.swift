//
// Created by Андрей Парамонов on 16.12.2023.
//

import UIKit

public final class StatisticsAssembly {
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembly = servicesAssembler
    }

    public func build() -> UIViewController {
        let viewModel = StatisticsViewModelImpl(userService: servicesAssembly.userService,
                                                userDefaultsStore: servicesAssembler.userDefaultsStore)
        return StatisticsViewController(viewModel: viewModel, servicesAssembler: servicesAssembly)
    }
}
