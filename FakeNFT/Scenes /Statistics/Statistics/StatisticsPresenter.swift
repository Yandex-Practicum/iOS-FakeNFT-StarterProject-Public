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
                DispatchQueue.main.async {
                               self.view?.updateUsers(nftUsers)
                           }
            }
        })
    }
}

// MARK: StatisticsPresenterProtocol

extension StatisticsPresenter: StatisticsPresenterProtocol {
    func getUserList() -> [NFTUser] {
        return usersList
    }
}
