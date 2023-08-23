//
//  NFTSortingViewModel.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import Foundation

protocol NFTSortingViewModel {
    func sorting(with: SortingTraits)
}

final class NFTSortingViewModelImpl: NFTSortingViewModel {
    private let output: (SortingTraits) -> Void

    init(output: @escaping (SortingTraits) -> Void) {
        self.output = output
    }

    func sorting(with: SortingTraits) {
        output(with)
    }
}
