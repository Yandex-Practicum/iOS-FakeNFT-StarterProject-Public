//
//  PaymentResultResponse.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 12.07.2023.
//

import Foundation

struct PaymentResultResponse: Decodable {
    let success: Bool
    let orderId: String
    let id: String
}
