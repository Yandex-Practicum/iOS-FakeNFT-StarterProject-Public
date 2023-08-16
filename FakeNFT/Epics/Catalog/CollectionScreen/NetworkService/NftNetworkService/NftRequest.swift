//
//  NftRequest.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import Foundation

final class NftRequest: NetworkRequest {
    var httpMethod: HttpMethod
    var endpoint: URL? {
        URL(string: "https://\(Constants.host.rawValue)/api/v1/nft?author=\(id)")
    }
    private var id: String
    
    init(httpMethod: HttpMethod, id: String) {
        self.httpMethod = httpMethod
        self.id = id
    }
}
