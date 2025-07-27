//
//  CurrencyModel.swift
//  FakeNFT
//
//  Created by Max on 29.05.2025.
//

import SwiftUI

struct Currency: Hashable, Codable, Identifiable  {
    let title: String
    let name: String
    let image: String
    let id: String
    
    static var mock: Self {
        .init(title: "BTC", name: "Bitcoin", image: "bitcoin", id: "")
    }
}

