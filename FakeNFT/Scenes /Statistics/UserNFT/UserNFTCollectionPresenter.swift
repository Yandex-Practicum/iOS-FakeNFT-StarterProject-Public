//
//  UserNFTCollectionPresenter.swift
//  FakeNFT
//
//  Created by Сергей on 02.05.2024.
//

import Foundation

protocol UserNFTCollectionPresenterProtocol {
    var visibleNFT: [NFTModel] { get set }
}

final class UserNFTCollectionPresenter: UserNFTCollectionPresenterProtocol {
    
    var visibleNFT: [NFTModel] = [] 
    
    private func updateVisibleNFT(name: String, indexPath: IndexPath) {
        
    }
}
