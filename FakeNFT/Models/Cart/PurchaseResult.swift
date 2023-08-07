//
//  PurchaseResult.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 07.08.2023.
//

import Foundation

struct PurchaseResult: Decodable {
    let id: String
    let orderId: String
    let success: Bool
}
