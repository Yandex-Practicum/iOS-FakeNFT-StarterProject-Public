//
//  UserNFTCollectionPresenter.swift
//  FakeNFT
//
//  Created by Сергей on 02.05.2024.
//

import UIKit // позже кит уберу и оставлю Foundation. На данный момент кит здесь чтобы задействовать UIimage

protocol UserNFTCollectionPresenterProtocol {
    var visibleNFT: [NFTModel] { get set }
}

final class UserNFTCollectionPresenter: UserNFTCollectionPresenterProtocol {
    
    var visibleNFT: [NFTModel] = [] 
    
    private func updateVisibleNFT(name: String, indexPath: IndexPath) {
        
    }
}
