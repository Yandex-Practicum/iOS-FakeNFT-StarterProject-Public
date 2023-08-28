//
//  PaymentModel.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 15/08/2023.
//

import Foundation

struct PaymentModel: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
