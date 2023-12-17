//
// Created by Андрей Парамонов on 16.12.2023.
//

import Foundation

protocol UserProfileViewModel {
    var userName: String { get }
    var userDescription: String { get }
    var userAvatar: URL { get }
    var userCollectionSize: Int { get }

    func goToSiteButtonTapped()

    var openSite: ((URLRequest) -> Void)? { get set }
}

final class UserProfileViewModelImpl: UserProfileViewModel {
    private let user: User

    init (user: User) {
        self.user = user
    }

    var userName: String {
        user.name
    }

    var userDescription: String {
        user.description
    }

    var userAvatar: URL {
        user.avatar
    }

    var userCollectionSize: Int {
        user.nfts.count
    }

    func goToSiteButtonTapped() {
        let url = user.website
        openSite?(URLRequest(url: url))
    }

    var openSite: ((URLRequest) -> Void)?
}
