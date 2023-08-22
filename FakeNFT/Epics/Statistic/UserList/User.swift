//
//  User.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 29.07.2023.
//

import Foundation

struct User {
    let uuid = UUID()

    let ranking: String
    let avatarURL: URL?
    let username: String
    let nftCount: String
    let description: String
    let nfts: [Int]
}

extension User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

extension Array where Element == User {
    func sortByRank() -> [User] {
        return self.sorted { user, newUser in
            if let rank1 = Int(user.ranking), let rank2 = Int(newUser.ranking)  {
                return rank1 > rank2
            }
            return false
        }
    }

    func sortedByName() -> [User] {
        return self.sorted { $0.username < $1.username }
    }

    func sortByNft() -> [User] {
        return self.sorted { $0.nftCount > $1.nftCount }
    }
}
