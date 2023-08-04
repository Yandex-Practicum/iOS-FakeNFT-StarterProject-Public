//
//  CartCellViewModelFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 03.08.2023.
//

import UIKit.UIImage

final class NFTCartCellViewModelFactory {
    static func makeNFTCartCellViewModel(
        id: String,
        name: String,
        image: UIImage?,
        rating: Int,
        price: Double
    ) -> NFTCartCellViewModel {
        return NFTCartCellViewModel(
            id: id,
            name: name,
            image: image,
            rating: rating,
            price: price
        )
    }
}
