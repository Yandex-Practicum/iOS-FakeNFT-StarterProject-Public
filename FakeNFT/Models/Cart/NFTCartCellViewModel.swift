//
//  NFTCartCellViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 03.08.2023.
//

import UIKit

struct NFTCartCellViewModel {
    let id: String
    let name: String
    let image: UIImage?
    let rating: Int
    let price: Double
}

typealias OrderViewModel = [NFTCartCellViewModel]
