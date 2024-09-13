//
//  NftsRequest.swift
//  FakeNFT
//
//  Created by Дмитрий on 13.09.2024.
//

import Foundation

struct NftsRequest: NetworkRequest {
    let page: Int
    let size: Int
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft?page=\(page)&size=\(size)")
    }
    var dto: Dto?
}
