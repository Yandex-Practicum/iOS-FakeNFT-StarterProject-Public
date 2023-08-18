//
//  GetUserRequest.swift
//  FakeNFT
//
//  Created by macOS on 22.06.2023.
//

import Foundation

struct GetNftRequest: NetworkRequest {
    let nftId: Int
    
    var endpoint: URL? {
        URL(string: "https://648cbc238620b8bae7ed51a1.mockapi.io/api/v1/nft/\(nftId)")
    }
    var httpMethod: HttpMethod {
        .get
    }
}
