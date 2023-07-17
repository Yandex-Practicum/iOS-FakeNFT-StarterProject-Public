//
//  ProfileNFTRequest.swift
//  FakeNFT
//
//  Created by Илья Валито on 21.06.2023.
//

import Foundation

struct ProfileNFTRequest: NetworkRequest {

    var nftID: String
    var httpMethod: HttpMethod
    var dto: Encodable?
    var endpoint: URL? {
        URL(string: "https://648cbc0b8620b8bae7ed515f.mockapi.io/api/v1/nft/\(nftID)")
    }
}
