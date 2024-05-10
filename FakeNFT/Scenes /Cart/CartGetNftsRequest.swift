//
//  CartGetNfts.swift
//  FakeNFT
//
//  Created by Александр Акимов on 03.05.2024.
//

import Foundation

struct CartGetNftsRequest: NetworkRequest {
    var endpoint: URL?
    init(nftId: String) {
        guard let endpoint = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/nft/\(nftId)") else { return }
        self.endpoint = endpoint
    }
}
