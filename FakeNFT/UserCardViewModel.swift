//
//  UserCardViewModel.swift
//  FakeNFT
//
//  Created by Anastasia on 04.06.2025.
//

import Foundation

@MainActor
final class UserCardViewModel: ObservableObject {
    @Published var user: User

    init(user: User) {
        self.user = user
    }
}
