//
//  CollectionScreenNftCellPresenter.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 18.08.2023.
//

import Foundation

final class CollectionScreenNftCellPresenter: CollectionScreenNftCellPresenterProtocol {
    private(set) var nft: NftModel
    private let basketService = BasketService.shared
    private let likeService = LikeService.shared
    
    init(nft: NftModel) {
        self.nft = nft
    }
    
    func viewAddedNftToBasket() {
        basketService.addNFTToBasket(nft)
    }
    
    func viewRemovedNftFromBasket() {
        basketService.removeNFTFromBasket(nft)
    }
    
    func viewDidSetLike() {
        likeService.setLike(nftId: nft.id)
    }
    
    func viewDidSetUnlike() {
        likeService.removeLike(nftId: nft.id)
    }
}
