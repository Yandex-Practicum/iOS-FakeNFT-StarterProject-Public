//
//  NFTDetailsViewModel.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

protocol NFTDetailsViewModel {
    var details: NFTDetails { get }
    
    func selectNft(index: Int)
    
    func unselectNft(index: Int)
    
    func addTofavouriteNft(index: Int)
    
    func removeFromFavouriteNft(index: Int)
}

final class NFTDetailsViewModelImpl: NFTDetailsViewModel {
    private(set) var details: NFTDetails

    init(details: NFTDetails) {
        self.details = details
    }
    
    func selectNft(index: Int) {
        print(details.items[index])
    }
    
    func unselectNft(index: Int) {
        print(details.items[index])
    }
    
    func addTofavouriteNft(index: Int) {
        print(details.items[index])
    }
    
    func removeFromFavouriteNft(index: Int) {
        print(details.items[index])
    }
}
