//
//  CurrencyModel.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 14.12.2023.
//

import Foundation

typealias CurrencyModel = [CurrencyModelElement]

struct CurrencyModelElement: Codable {
    let title: String
    let name: String
    let image: String
    let id: String
}
