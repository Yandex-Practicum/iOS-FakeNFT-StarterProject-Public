//
// Created by Андрей Парамонов on 16.12.2023.
//

import Foundation

protocol UserProfileViewModel {
}

final class UserProfileViewModelImpl: UserProfileViewModel {
    private let user: User

    init (user: User) {
        self.user = user
    }
}
