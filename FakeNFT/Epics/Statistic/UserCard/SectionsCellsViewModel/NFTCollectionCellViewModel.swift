//
//  CollectionCellViewModel.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 05.08.2023.
//

import Foundation

final class NFTCollectionCellViewModel {
    let nfts: [Int]

    init(nfts: [Int]) {
        self.nfts = nfts
    }

    var formattedNftsNumber: String {
        "(\(nfts.count))"
    }
}

extension NFTCollectionCellViewModel: Hashable {
    static func == (lhs: NFTCollectionCellViewModel, rhs: NFTCollectionCellViewModel) -> Bool {
        lhs.nfts == rhs.nfts
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(nfts)
    }
}
