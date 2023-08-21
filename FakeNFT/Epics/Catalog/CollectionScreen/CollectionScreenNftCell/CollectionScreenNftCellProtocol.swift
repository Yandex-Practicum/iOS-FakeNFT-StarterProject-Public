//
//  CollectionScreenNftCellProtocol.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 18.08.2023.
//

import Foundation

protocol CollectionScreenNftCellPresenterProtocol {
    var nft: NftModel { get }
    func viewAddedNftToBasket()
    func viewRemovedNftFromBasket()
    func viewDidSetLike()
    func viewDidSetUnlike()
}
