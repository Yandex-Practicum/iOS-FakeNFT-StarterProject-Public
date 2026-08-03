//
//  Currency.swift
//  FakeNFT
//
//  Created by Сергей Петров on 20.07.2026.
//

import Foundation

struct Currency: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let name: String
    let image: String
}
