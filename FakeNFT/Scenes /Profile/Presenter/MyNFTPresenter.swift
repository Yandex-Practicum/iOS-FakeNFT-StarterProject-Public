//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 25.04.2024.
//

import Foundation

protocol MyNFTPresenterProtocol: AnyObject {
    var view: MyNFTViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class MyNFTPresenter {
    //MARK:  - Public Properties
    weak var view: MyNFTViewControllerProtocol?
    var nfts: [NFT] = []
    var nftID: [String]
    var likedNFT: [String]
    
    // MARK: - Initializers
    init(nftID: [String], likedNFT: [String]) {
        self.nftID = nftID
        self.likedNFT = likedNFT
    }
}


