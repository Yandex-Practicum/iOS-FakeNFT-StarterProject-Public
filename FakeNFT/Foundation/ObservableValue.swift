//
//  ObservableValue.swift
//  FakeNFT
//
//  Created by admin on 25.03.2024.
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
