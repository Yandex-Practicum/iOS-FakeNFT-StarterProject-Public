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
    @Published var isShowingErrorAlert: Bool = false
    private var users: [User] = []
    private let usersService: UsersService
    
    @AppStorage("ratingSort") private var currentSorting: RatingFilterType = .rating
    
    init(usersService: UsersService) {
        self.usersService = usersService
    }
    
    func loadUsers() {
        if !users.isEmpty { return }
        isLoading = true
        
        usersService.loadUsers { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success(let users):
                    self.users = users
                    self.filterUsers(by: self.currentSorting)
                case .failure(_):
                    self.isShowingErrorAlert = true
                }
            }
        }
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
