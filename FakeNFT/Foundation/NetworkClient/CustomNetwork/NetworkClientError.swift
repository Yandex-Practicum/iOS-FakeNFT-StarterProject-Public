//
//  NetworkClientError.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 07/07/2024.
//

import Foundation

import Foundation

extension NetworkClientError {
    static func custom(
        _ message: String
    ) -> NetworkClientError {
        return NetworkClientError.urlRequestError(
            NSError(
                domain: "CustomServicesAssembly",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: message]
            )
        )
    }
}
