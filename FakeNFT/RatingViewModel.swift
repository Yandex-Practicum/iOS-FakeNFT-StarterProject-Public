//
//  RatingViewModel.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import SwiftUI

@MainActor
final class RatingViewModel: ObservableObject {
    @Published var filteredUsers: [User] = []
    @Published var isLoading: Bool = false
    @Published var isShowingFilterSheet: Bool = false
    private var users: [User] = []
    
    @AppStorage("ratingSort") private var currentSorting: RatingFilterType = .rating
    
    let user1 = User(
        id: "1",
        name: "Test user1",
        avatar: "",
        description: "",
        website: "",
        nfts: ["1", "2", "3"],
        rating: "1"
    )
    let user2 = User(
        id: "2",
        name: "Test user2",
        avatar: "",
        description: "",
        website: "",
        nfts: ["1", "2"],
        rating: "2"
    )
    
    func loadUsers() {
        if !users.isEmpty { return }
        users = [user1, user2]
        filteredUsers = users
    }
    
    func filterUsers(by type: RatingFilterType) {
        switch type {
        case .name:
            currentSorting = .name
            filteredUsers = users.sorted { $0.name.lowercased() < $1.name.lowercased() }
        case .rating:
            currentSorting = .rating
            filteredUsers = users.sorted { Int($0.rating) ?? 0 < Int($1.rating) ?? 0 }
        }
    }
}

enum RatingFilterType: String {
    case name
    case rating
}
