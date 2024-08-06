//
//  UserCollectionPresenter.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit

protocol UserCollectionPresenterProtocol: AnyObject {
    func getCollectionList() -> [NFTItem]
    func setUser(with newUser: NFTUser)
    func updateSelf(view: UserCollectionViewProtocol)
}

final class UserCollectionPresenter {
    private var userCollectionNetworkService : UserCollectionNetworkServiceProtocol
    private var selectedUser : NFTUser?
    private var collectionList : [NFTItem] = []
    
    weak var view: UserCollectionViewProtocol?

    init(selectedUser : NFTUser) {
        self.selectedUser = selectedUser
        self.userCollectionNetworkService = UserCollectionNetworkService(networkClient: DefaultNetworkClient())
        setupPresenter()
    }
    
    private func setupPresenter(){
        guard let selectedUser = selectedUser else {return}
        userCollectionNetworkService.fetchNFTCollectionFrom(user: selectedUser, completion: {[weak self] _ in
             print("Setting up presenter with user: \(selectedUser)")
               guard let self = self,
                  let view = self.view  as? UIViewController else { return }
            self.collectionList = userCollectionNetworkService.getNFTCollection()
            if self.collectionList.isEmpty{
                ErrorAlertController.showError(on: view) { [weak self] in
                  self?.setupPresenter()
                }
            } else {
                self.view?.updateCollectionList(with: self.collectionList)
                print("Successfully fetched item: \(collectionList)")
            }
        })
    }
}

// MARK: UsersCollectionPresenterProtocol

extension UserCollectionPresenter: UserCollectionPresenterProtocol {
    

    
    func setUser(with newUser: NFTUser) {
        self.selectedUser = newUser
    }
    
    func updateSelf(view: any UserCollectionViewProtocol) {
        self.view = view
    }

    func getCollectionList() -> [NFTItem] {
        return collectionList
    }
}
