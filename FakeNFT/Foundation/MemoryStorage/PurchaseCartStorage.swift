//
//  PurchaseCartStorage.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 21.11.2023.
//

import Foundation

final class PurchaseCartStorage {
    static let shared = PurchaseCartStorage()
    var nfts: [String] = []

    private init() {}
}
