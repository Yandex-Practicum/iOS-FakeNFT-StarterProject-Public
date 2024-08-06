//
//  UserCollectionNetworkService.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 01.08.2024.
//

import Foundation
import ProgressHUD
import UIKit

final class UserCollectionItemNetworkRequest : NetworkRequest {
    var endpoint: URL?
    var token: String?
    var itemId: String?
    
    init(itemId: String?){
        guard let itemId = itemId else {return}
        let endpointURL = RequestConstants.baseURL + RequestConstants.itemById + itemId
        guard let endpoint = URL(string: endpointURL) else { return }
        self.endpoint = endpoint
        self.token = RequestConstants.token
    }
}

protocol UserCollectionNetworkServiceProtocol: AnyObject {
    func fetchNFTCollectionFrom(user: NFTUser, completion: @escaping (NFTItem) -> Void)
    func getNFTCollection() -> [NFTItem]
}

final class UserCollectionNetworkService: UserCollectionNetworkServiceProtocol {
    
    private var userCollection: [NFTItem] = []
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    convenience init() {
        self.init(networkClient: DefaultNetworkClient())
    }
    
    func fetchNFTCollectionFrom(user: NFTUser, completion: @escaping (NFTItem) -> Void) {
        ProgressHUD.show()
        self.userCollection = []
        
        let dispatchGroup = DispatchGroup()
        
        for itemId in user.nfts {
            dispatchGroup.enter()
            let request = UserCollectionItemNetworkRequest(itemId: itemId)
            networkClient.send(request: request , type: NFTItem.self){  [weak self] result in
                guard let self = self else { 
                    dispatchGroup.leave()
                    return }
                switch result {
                case .success(let nftItem):
                    self.userCollection.append(nftItem)
                    completion(nftItem)
                case .failure(let error):
                    if let window = currentWindow(),
                       let viewController = window.rootViewController {
                        ErrorAlertController.showError(on: viewController) {
                           self.fetchNFTCollectionFrom(user: user, completion: completion)
                        }
                    }
                }
                dispatchGroup.leave()
            }
        }
        ProgressHUD.dismiss()
    }
    
    func getNFTCollection() -> [NFTItem] {
        return userCollection
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

