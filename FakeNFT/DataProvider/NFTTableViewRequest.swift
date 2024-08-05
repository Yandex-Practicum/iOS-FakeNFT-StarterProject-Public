//
//  NFTTableViewRequest.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import Foundation

struct NFTTableViewRequest: NetworkRequest {
    var token: String?
    var endpoint: URL?

    init() {
        guard let endpoint = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/collections") else { return }
        self.endpoint = endpoint
        self.token = "edfc7835-684c-4eaf-a7b3-26ecea542ca3"
    }
}
