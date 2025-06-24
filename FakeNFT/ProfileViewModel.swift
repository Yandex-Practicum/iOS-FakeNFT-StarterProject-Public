//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Mac on 12.06.2025.
//

import Foundation

@MainActor

final class ProfileViewModel: ObservableObject {
    
    @Published var user: User
    init(user: User) {
        self.user = user
    }
    
}

