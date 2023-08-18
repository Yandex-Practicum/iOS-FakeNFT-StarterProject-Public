//
//  RatingViewModel.swift
//  FakeNFT
//
//  Created by macOS on 21.06.2023.
//

import Foundation

final class RatingViewModel {
    
    @Observable
    private(set) var userList: [User] = []
    
    @Observable
    private(set) var isLoading: Bool = false
    
    @Observable
    private(set) var errorMessage: String? = nil
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserNetworkService()) {
        self.userService = userService
    }
    
    func getUserList() {
        isLoading = true
        
        userService.getUserList { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let userList):
                    let sortedList = self?.sortByRating(userList: userList) ?? []
                    self?.userList = sortedList
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func sortByName() {
        let sortedList = userList.sorted { user1, user2 in
            user1.name < user2.name
        }
        self.userList = sortedList
    }
    
    func sortByRating() {
        let sortedList = sortByRating(userList: userList)
        self.userList = sortedList
    }
    
    private func sortByRating(userList: [User]) -> [User] {
        userList.sorted { user1, user2 in
            (Int(user1.rating) ?? 0) > (Int(user2.rating) ?? 0)
        }
    }
    
}
