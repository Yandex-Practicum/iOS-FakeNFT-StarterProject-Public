//
//  NFTInfoModelView.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 07.08.2023.
//

import Foundation

protocol NFTInfoViewModel {
    var imageURL: String { get }
    var sectionName: String { get }
    var sectionAuthor: String { get }
    var sectionDescription: String { get }
    var nfts: Box<[NFT]> { get }
    
    func toggleNftSelectedState(index: Int)
    func toggleNftFavouriteState(index: Int)
}

final class NFTInfoViewModelImpl: NFTInfoViewModel {
    private(set) var nfts: Box<[NFT]>
    let imageURL: String
    let sectionName: String
    let sectionAuthor: String
    let sectionDescription: String

    private let storage: NFtStorageService

    init(storage: NFtStorageService, details: NFTInfo) {
        self.storage = storage
        imageURL = details.imageURL
        sectionName = details.sectionLabel
        sectionAuthor = details.sectionAuthor
        sectionDescription = details.sectionInfo
        nfts = .init(details.items.map { NFT(model: $0) })
    }

    func toggleNftSelectedState(index: Int) {
        nfts.value[index].isSelected.toggle()

        let nftValue = nfts.value[index]
        
        nfts.value[index].isSelected
        ? storage.selectNft(nftValue)
        : storage.unselectNft(nftValue)
    }

    func toggleNftFavouriteState(index: Int) {
        nfts.value[index].isFavourite.toggle()

        let nftValue = nfts.value[index]
        
        nfts.value[index].isSelected
        ? storage.addToFavourite(nftValue)
        : storage.removeFromFavourite(nftValue)
    }
}
