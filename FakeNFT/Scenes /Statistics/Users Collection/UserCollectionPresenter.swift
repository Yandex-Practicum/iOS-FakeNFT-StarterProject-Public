//
//  UserCollectionPresenter.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit
import ProgressHUD

protocol UserCollectionPresenterProtocol: AnyObject {
    func getCollectionList() -> [NFTItem]
    func setUser(with newUser: NFTUser)
    func loadData(completion: @escaping () -> Void)   
}

final class UserCollectionPresenter {
    private var userCollectionNetworkService: UserCollectionNetworkServiceProtocol
    private var selectedUser: NFTUser?
    private var collectionList: [NFTItem] = []
    
    weak var view: UserCollectionViewProtocol?

    init(selectedUser: NFTUser) {
        self.selectedUser = selectedUser
        self.userCollectionNetworkService = UserCollectionNetworkService(networkClient: DefaultNetworkClient())
    }
    
    func loadData(completion: @escaping () -> Void) {
        collectionList = []
        guard let selectedUser = selectedUser else { return }
            userCollectionNetworkService.fetchNFTCollectionFrom(user: selectedUser) { [weak self] in
                guard let self = self else { return }
                self.collectionList = self.userCollectionNetworkService.getNFTCollection()
                if !self.collectionList.isEmpty {
                    self.view?.updateCollectionList(with: self.collectionList)
                }
                self.view?.hideLoading()
                completion()
            }
        }
}

// MARK: UsersCollectionPresenterProtocol

extension UserCollectionPresenter: UserCollectionPresenterProtocol {
    
    func setUser(with newUser: NFTUser) {
        self.selectedUser = newUser
    }
    
    func getCollectionList() -> [NFTItem] {
        return collectionList
    }
}
