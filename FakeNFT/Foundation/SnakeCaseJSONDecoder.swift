//
//  SnakeCaseJSONDecoder.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/19/25.
//
import Foundation

final class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
