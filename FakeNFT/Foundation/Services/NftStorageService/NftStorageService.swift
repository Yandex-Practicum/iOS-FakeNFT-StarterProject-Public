//
//  NftStorageService.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 02.08.2023.
//

import Foundation

protocol NFtStorageService {
    var favouriteNfts: Box<[NFT]> { get }
    var selectedNfts: Box<[NFT]> { get }

    func selectNft(_ nft: NFT)
    func unselectNft(_ nft: NFT)

    func addToFavourite(_ nft: NFT)
    func removeFromFavourite(_ nft: NFT)
}
