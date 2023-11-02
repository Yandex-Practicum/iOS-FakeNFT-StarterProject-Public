//
//  UserViewCellViewModel.swift
//  FakeNFT
//
//  Created by Konstantin Zuykov on 02.11.2023.
//

import Foundation

final class UserViewCellViewModel {
    private let user: User
    private let cellIndex: Int

    var index: String {
        return String(cellIndex + 1)
    }

    var name: String {
        return user.name
    }

    var count: String {
        return String(user.nfts.count)
    }

    var avatarURL: URL? {
        return URL(string: user.avatar)
    }

    init(user: User, cellIndex: Int) {
        self.user = user
        self.cellIndex = cellIndex
    }
}
