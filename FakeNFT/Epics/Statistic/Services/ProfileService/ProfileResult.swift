//
//  Profile.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 13.08.2023.
//

import Foundation

struct ProfileResult: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts, likes: [String]
    let id: String
}

extension Array where Element == String {
    func convertToInts() -> [Int] {
        return compactMap { Int($0) }
    }
}
