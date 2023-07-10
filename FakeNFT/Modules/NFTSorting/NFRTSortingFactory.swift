//
//  NFRTSortingFactory.swift
//  FakeNFT
//
//  Created by Kirill on 06.07.2023.
//

import Foundation

import UIKit

struct NFTSortingFactory {
    static func create(output: @escaping (SortingCategory) -> Void) -> UIAlertController {
        let viewModel = NFTSortingViewModelImpl(output: output)
        let alertController = NFTSortingAlertController(viewModel: viewModel)
        return alertController
    }
}
