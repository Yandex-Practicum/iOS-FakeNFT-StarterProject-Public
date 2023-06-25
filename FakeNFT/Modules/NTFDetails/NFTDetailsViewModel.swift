//
//  NFTDetailsViewModel.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

protocol NFTDetailsViewModel {
    var details: NFTDetails { get }
}

final class NFTDetailsViewModelImpl: NFTDetailsViewModel {
    private(set) var details: NFTDetails

    init(details: NFTDetails) {
        self.details = details
    }
}
