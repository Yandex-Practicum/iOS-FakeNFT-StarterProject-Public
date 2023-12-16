//
// Created by Андрей Парамонов on 15.12.2023.
//

import Foundation

public struct User: Decodable {
    let name: String
    let avatar: URL
    let description: String
    let website: URL
    let nfts: [Nft]
    let rating: String
    let id: String
}
