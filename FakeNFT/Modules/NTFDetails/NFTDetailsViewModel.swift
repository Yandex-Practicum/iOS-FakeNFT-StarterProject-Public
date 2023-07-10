//
//  NFTDetailsViewModel.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

protocol NFTDetailsViewModel {
    var imageURL: String { get }
    var sectionName: String { get }
    var sectionAuthor: String { get }
    var sectionDescription: String { get }
    var nfts: Box<[NFT]> { get }
    func selectedNft(index: Int)
    func selectFavourite(index: Int)
}

final class NFTDetailsViewModelImpl: NFTDetailsViewModel {
    private(set) var nfts: Box<[NFT]>
    let imageURL: String
    let sectionName: String
    let sectionAuthor: String
    let sectionDescription: String

    private let nftStorageService: NFtStorageService

    init(nftStorageService: NFtStorageService, details: NFTDetails) {
        self.nftStorageService = nftStorageService
        imageURL = details.imageURL
        sectionName = details.sectionName
        sectionAuthor = details.sectionAuthor
        sectionDescription = details.sectionDescription
        nfts = .init(details.items.map { NFT($0) })
    }

    func selectedNft(index: Int) {
        nfts.value[index].isSelected.toggle()

        nfts.value[index].isSelected
        ? nftStorageService.selectNft(nfts.value[index])
        : nftStorageService.unselectNft(nfts.value[index])

    }

    func selectFavourite(index: Int) {
        nfts.value[index].isFavourite.toggle()

        nfts.value[index].isSelected
        ? nftStorageService.addToFavourite(nfts.value[index])
        : nftStorageService.removeFromFavourite(nfts.value[index])
    }
}
