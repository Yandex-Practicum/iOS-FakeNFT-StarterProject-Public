//
//  Box.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 04.08.2023.
//

import Foundation

public final class Box<T> {
    typealias Listener = (T) -> Void

    var listener: Listener?

    public var value: T {
        didSet {
            self.listener?(self.value)
        }
    }

    public init(_ value: T) {
        self.value = value
    }

    func bind(listener: Listener?) {
        self.listener = listener
        self.listener?(self.value)
    }
}
