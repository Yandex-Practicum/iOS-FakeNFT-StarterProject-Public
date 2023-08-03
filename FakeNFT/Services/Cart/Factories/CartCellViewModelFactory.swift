//
//  CartCellViewModelFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 03.08.2023.
//

import UIKit

final class NFTCartCellViewModelFactory {
    func makeNFTCartCellViewModel(
        id: Int,
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
