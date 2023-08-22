//
//  NftStorageQueue.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 07.08.2023.
//

import Foundation

final class NftStorageQueue {
    static let shared = NftStorageQueue()
    private(set) var queue: DispatchQueue
    
    private init() {
        queue = DispatchQueue(label: "NftStorageQueue.queue")
    }
}
