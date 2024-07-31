//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit

protocol StatisticsPresenterProtocol: AnyObject {
    func getUserList() -> [NFTUser]
    func loadUserCard(with selectedUser : NFTUser) -> UserCardViewController
}

final class StatisticsPresenter {
    private var statisticsUsersNetworkService : StatisticsUsersNetworkServiceProtocol
    private var usersList : [NFTUser] = []
    
    weak var view: StatisticsViewProtocol?
   
    init(view: StatisticsViewController) {
        self.view = view
        self.statisticsUsersNetworkService = StatisticsUsersNetworkService(networkClient: DefaultNetworkClient())
        setupPresenter()
    }
    
    private func setupPresenter(){
        statisticsUsersNetworkService.fetchNFTUsers(completion: {[weak self] nftUsers in
            print("Setting up presenter with users: \(nftUsers)")
            guard let self = self,
                  let view = self.view  as? UIViewController else { return }
            if nftUsers.isEmpty {
                ErrorAlertController.showError(on: view) { [weak self] in
                    self?.setupPresenter()
                }
            } else {
                print("Successfully fetched users: \(nftUsers)")
                self.usersList = nftUsers
                self.view?.updateUsers(with: nftUsers)
                
            }
        })
    }
    
 
}

// MARK: StatisticsPresenterProtocol

extension StatisticsPresenter: StatisticsPresenterProtocol {
    func getUserList() -> [NFTUser] {
        return usersList
    }
    
    func loadUserCard(with selectedUser : NFTUser) -> UserCardViewController{
        let userCardViewController = UserCardViewController()
        userCardViewController.presenter = UserCardPresenter()
        userCardViewController.presenter?.setUser(with: selectedUser)
        userCardViewController.modalPresentationStyle = .fullScreen
        return userCardViewController
    }
}
