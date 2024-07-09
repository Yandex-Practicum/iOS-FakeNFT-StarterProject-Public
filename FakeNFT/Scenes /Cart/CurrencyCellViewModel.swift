//
//  CurrencyCellViewModel.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 09/07/2024.
//

import Combine
import Foundation

struct CurrencyViewData {
    let title: String
    let name: String
    let imageURLString: String
}

final class CurrencyCellViewModel: ObservableObject {
    @Published var viewData: CurrencyViewData
    
    init(currency: Currency) {
        self.viewData = CurrencyViewData(
            title: currency.title,
            name: currency.name,
            imageURLString: currency.image
        )
    }
}
