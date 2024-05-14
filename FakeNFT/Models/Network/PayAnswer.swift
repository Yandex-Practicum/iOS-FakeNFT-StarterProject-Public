//
//  PayAnswer.swift
//  FakeNFT
//
//  Created by Александр Акимов on 14.05.2024.
//

import Foundation

struct PayAnswer: Decodable {
    let id: String
    let orderId: String
    let success: Bool
}
