//
//  NFTSortingFactory.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import UIKit

struct NFTSortingFactory {
    static func create(output: @escaping (SortingTraits) -> Void) -> UIAlertController {
        let viewModel = NFTSortingViewModelImpl(output: output)
        let alertController = NFTSortingAlertController(viewModel: viewModel)
        return alertController
    }
}
