//
//  NetworkError.swift
//  FakeNFT
//
//  Created by Dinara on 24.03.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case decodingError(Error)
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
