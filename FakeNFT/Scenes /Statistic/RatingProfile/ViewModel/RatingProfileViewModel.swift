//
//  RatingViewModel.swift
//  FakeNFT
//
//  Created by macOS on 21.06.2023.
//

import Foundation

final class RatingProfileViewModel {
    
    @Observable
    private(set) var user: User? = nil
    
    @Observable
    private(set) var isLoading: Bool = false
    
    @Observable
    private(set) var errorMessage: String? = nil
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserNetworkService()) {
        self.userService = userService
    }
    
    func getUser(userId: Int) {
        isLoading = true
        
        userService.getUser(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let user):
                    self?.user = user
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
}
