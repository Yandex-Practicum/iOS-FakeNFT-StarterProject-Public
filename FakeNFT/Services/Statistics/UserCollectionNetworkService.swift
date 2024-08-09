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
    func fetchNFTCollectionFrom(user: NFTUser, completion: @escaping () -> Void)
    func getNFTCollection() -> [NFTItem]
    func dismissProgressIndicator()
}

final class UserCollectionNetworkService: UserCollectionNetworkServiceProtocol {
    func dismissProgressIndicator() {
        semaphore.wait()
             if ongoingTasks > 0 {
                 dispatchGroup.leave()
                 ongoingTasks -= 1
             }
             semaphore.signal()
    }
    
    
    private var userCollection: [NFTItem] = []
    
    private var ongoingTasks = 0
    private let semaphore = DispatchSemaphore(value: 1)
    let dispatchGroup = DispatchGroup()
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    convenience init() {
        self.init(networkClient: DefaultNetworkClient())
    }
    
    func fetchNFTCollectionFrom(user: NFTUser, completion: @escaping () -> Void) {
        ProgressHUD.show()
        self.userCollection = []
       
        for itemId in user.nfts {
            dispatchGroup.enter()
            semaphore.wait()
            ongoingTasks += 1
            semaphore.signal()
            let request = UserCollectionItemNetworkRequest(itemId: itemId)
            networkClient.send(request: request , type: NFTItem.self){  [weak self] result in
                guard let self = self else { 
                    self?.dispatchGroup.leave()
                    return }
                switch result {
                case .success(let nftItem):
                    self.userCollection.append(nftItem)
                case .failure(_):
                    if let window = currentWindow(),
                       let viewController = window.rootViewController {
                        ErrorAlertController.showError(on: viewController) {
                           self.fetchNFTCollectionFrom(user: user, completion: completion)
                        }
                    }
                }
                self.dismissProgressIndicator()
            }
        }
        dispatchGroup.notify(queue: .main) {
            ProgressHUD.dismiss()
            completion()
            }
       
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

