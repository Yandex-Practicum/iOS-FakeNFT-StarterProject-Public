//
//  Executors.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import Foundation

final class Executors {
    private init() {}

    static func asyncMain(block: @escaping ExecutionBlock) {
        DispatchQueue.main.async {
            block()
        }
    }
}
