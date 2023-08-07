//
//  CurrencyViewModelFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 07.08.2023.
//

import UIKit.UIImage

struct CurrencyViewModelFactory {
    static func makeCurrencyViewModel(
        id: String,
        title: String,
        name: String,
        image: UIImage
    ) -> CurrencyCellViewModel {
        return CurrencyCellViewModel(id: id, title: title, name: name, image: image)
    }
}
