//
//  Currency.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 07.08.2023.
//

import Foundation

struct Currency: Decodable {
    let id: String
    let title: String
    let name: String
    let image: String
}

typealias CurrenciesResult = [Currency]
