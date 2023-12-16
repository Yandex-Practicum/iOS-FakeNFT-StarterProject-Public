//
// Created by Андрей Парамонов on 16.12.2023.
//

import Foundation

protocol UserProfileViewModel {
}

final class UserProfileViewModelImpl: UserProfileViewModel {
    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
    }
}
