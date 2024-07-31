//
//  StatisticsUsersNetworkService.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 28.07.2024.
//

import Foundation
import ProgressHUD
import UIKit

final class StatisticsUsersNetworkRequest : NetworkRequest {
    var endpoint: URL?
    var token: String?
    
    init() {
        let endpointURL = RequestConstants.baseURL + RequestConstants.usersURL
        guard let endpoint = URL(string: endpointURL) else { return }
        self.endpoint = endpoint
        self.token = RequestConstants.token
    }
}

protocol StatisticsUsersNetworkServiceProtocol: AnyObject {
    func fetchNFTUsers(completion: @escaping ([NFTUser]) -> Void)
    func getNFTUsers() -> [NFTUser]
}

final class StatisticsUsersNetworkService: StatisticsUsersNetworkServiceProtocol {
    
    
    private var usersNFT: [NFTUser] = []
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    convenience init() {
        self.init(networkClient: DefaultNetworkClient())
    }
    
    
    func getNFTUsers() -> [NFTUser] {
        return usersNFT
    }
    
    func fetchNFTUsers(completion: @escaping ([NFTUser]) -> Void) {
        ProgressHUD.show()
        let request = StatisticsUsersNetworkRequest()
        networkClient.send(request: request , type: [NFTUser].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nftUsers):
                print("Successfully fetched NFT users: \(nftUsers)")
                self.usersNFT = nftUsers
                completion(nftUsers)
            case .failure(let error):
                print("Failed to fetch NFT users with error: \(error)")
                completion([])
                if let window = currentWindow(),
                   let viewController = window.rootViewController {
                    ErrorAlertController.showError(on: viewController) {
                        self.fetchNFTUsers(completion: completion)
                    }
                }
            }
            ProgressHUD.dismiss()
        }
    }
    
    private func currentWindow() -> UIWindow? {
        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first {
            return windowScene.windows.first { $0.isKeyWindow }
        }
        return nil
    }
}
