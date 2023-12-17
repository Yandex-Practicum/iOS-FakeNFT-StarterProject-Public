//
// Created by Андрей Парамонов on 16.12.2023.
//

import UIKit

public final class UserProfileAssembly {
    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    public func build(user: User) -> UIViewController {
        let viewModel = UserProfileViewModelImpl(user: user)
        return UserProfileViewController(viewModel: viewModel, servicesAssembler: servicesAssembler)
    }
}
