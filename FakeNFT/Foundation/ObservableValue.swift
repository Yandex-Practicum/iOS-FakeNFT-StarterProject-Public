//
//  ObservableValue.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 10.12.2023.
//

import Foundation

@propertyWrapper
final class Observable<T> {

    private var observers: [(T) -> Void] = []

    var wrappedValue: T {
        didSet {
            observers.forEach { $0(wrappedValue) }
        }
    }

    var projectedValue: Observable<T> {
        self
    }

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    func bind(observer: @escaping (T) -> Void) {
        observers.append(observer)
    }
}
