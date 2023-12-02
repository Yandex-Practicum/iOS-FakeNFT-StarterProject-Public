//
//  LikesStorage.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 20.11.2023.
//

import Foundation

final class LikesStorage {
    static let shared = LikesStorage()
    var likes: [String] = []

    private init() {}
}
