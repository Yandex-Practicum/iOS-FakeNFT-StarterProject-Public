//
//  NFTSortingViewModel.swift
//  FakeNFT
//
//  Created by Kirill on 06.07.2023.
//

import Foundation

protocol NFTSortingViewModel {
    func sorting(by: SortingCategory)
}

final class NFTSortingViewModelImpl: NFTSortingViewModel {
    private let output: (SortingCategory) -> Void

    init(output: @escaping (SortingCategory) -> Void) {
        self.output = output
    }

    func sorting(by: SortingCategory) {
        output(by)
    }
}

