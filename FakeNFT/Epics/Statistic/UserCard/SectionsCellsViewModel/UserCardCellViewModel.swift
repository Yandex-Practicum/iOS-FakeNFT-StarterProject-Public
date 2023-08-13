//
//  UserCardViewModel.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 05.08.2023.
//

import Foundation

final class UserCardCellViewModel {
    private let user: User

    init(user: User) {
        self.user = user
    }

    var name: String {
        user.username
    }

    var description: String {
        user.description
    }

    var avatarURL: URL? {
        user.avatarURL
    }
}

extension UserCardCellViewModel: Hashable {
    static func == (lhs: UserCardCellViewModel, rhs: UserCardCellViewModel) -> Bool {
        lhs.user == rhs.user
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(user)
    }
}
