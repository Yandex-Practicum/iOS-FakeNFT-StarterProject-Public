//
//  CartPayRequest.swift
//  FakeNFT
//
//  Created by Александр Акимов on 02.05.2024.
//

import Foundation

struct CartPayRequest: NetworkRequest {
    var endpoint: URL?
    init() {
        guard let endpoint = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/currencies") else { return }
        self.endpoint = endpoint
    }
}
