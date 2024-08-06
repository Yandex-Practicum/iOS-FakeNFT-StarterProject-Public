//
//  UserCardPresenter.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit

protocol UserCardPresenterProtocol: AnyObject {
    func setUser(with newUser: NFTUser)
    func updateUser()
    func updateSelf(view: UserCardViewProtocol)
    func loadUserCollection(with selectedUser : NFTUser) -> UserCollectionViewController
}


final class UserCardPresenter {

    weak var view: UserCardViewProtocol?
    private var selectedUser : NFTUser?
    init() {
       updateUser()
    }
  
}

// MARK: UserCardPresenterProtocol

extension UserCardPresenter: UserCardPresenterProtocol {
    func updateSelf(view: any UserCardViewProtocol) {
        self.view = view
    }
    
    func setUser(with newUser: NFTUser) {
        self.selectedUser = newUser
    }
    
    func updateUser(){
        view?.updateUser(with: self.selectedUser)
    }
    
    func loadUserCollection(with selectedUser : NFTUser) -> UserCollectionViewController {
        let userCollectionViewController = UserCollectionViewController()
        userCollectionViewController.presenter = UserCollectionPresenter(selectedUser: selectedUser)
        userCollectionViewController.modalPresentationStyle = .fullScreen
        return userCollectionViewController
    }
}
