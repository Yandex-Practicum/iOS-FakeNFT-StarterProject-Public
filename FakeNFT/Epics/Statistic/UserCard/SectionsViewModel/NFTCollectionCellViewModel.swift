//
//  CollectionCellViewModel.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 05.08.2023.
//

import Foundation

final class NFTCollectionCellViewModel {
    private let nftsNumber: String

    init(nftsNumber: String) {
        self.nftsNumber = nftsNumber
    }

    var formattedNftsNumber: String {
        "(\(nftsNumber))"
    }
}

extension NFTCollectionCellViewModel: Hashable {
    static func == (lhs: NFTCollectionCellViewModel, rhs: NFTCollectionCellViewModel) -> Bool {
        lhs.nftsNumber == rhs.nftsNumber
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(nftsNumber)
    }
}
