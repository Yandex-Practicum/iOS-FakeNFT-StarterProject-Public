//
// Created by Андрей Парамонов on 16.12.2023.
//

import UIKit

public final class UserProfileAssembly {
    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    public func build() -> UIViewController {
        let viewModel = UserProfileViewModelImpl(userService: servicesAssembler.userService)
        return UserProfileViewController(viewModel: viewModel)
    }
}
