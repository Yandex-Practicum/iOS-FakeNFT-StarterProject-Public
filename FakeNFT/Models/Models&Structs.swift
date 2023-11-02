//
//  Models&Structs.swift
//  FakeNFT
//
//  Created by Konstantin Zuykov on 02.11.2023.
//

import Foundation

enum StatSortType: String {
    case byName = "BYNAME"
    case byRating = "BYRATING"
}

struct Nft: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let id: String
}

struct Request: NetworkRequest {
    var endpoint: URL?
    var queryParameters: [String: String]?
    var httpMethod: HttpMethod
}

enum SortAttribute {
    case name
    case nftCount
}
