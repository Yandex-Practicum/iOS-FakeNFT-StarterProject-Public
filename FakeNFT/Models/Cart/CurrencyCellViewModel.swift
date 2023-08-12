//
//  CurrencyCellViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 07.08.2023.
//

import UIKit.UIImage

struct CurrencyCellViewModel {
    let id: String
    let title: String
    let name: String
    let image: UIImage?
}

typealias CurrenciesViewModel = [CurrencyCellViewModel]
