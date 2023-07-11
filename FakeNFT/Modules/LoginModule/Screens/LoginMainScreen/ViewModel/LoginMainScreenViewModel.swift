//
//  LoginMainScreenViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 10.07.2023.
//

import Foundation
import Combine

final class LoginMainScreenViewModel {
    
    @Published private (set) var requestResult: RequestResult?
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func enterTapped() {
        
    }
}

// MARK: - Ext Private
private extension LoginMainScreenViewModel {
    func sendLoginRequest() {
        requestResult = .loading
        let request = RequestConstructor.constructCatalogRequest(method: .get)
        networkClient.send(request: request, type: [NftCollection].self) { [weak self] result in
            
        }
    }
}
