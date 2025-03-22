//
//  Observable.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 20.03.2025.
//

import Foundation

typealias Listener<T> = (T) -> Void

final class Observable<T> {
    var value: T {
        didSet { listener?(value) }
    }
    
    private var listener: Listener<T>?
    
    init(value: T) {
        self.value = value
    }
    
    func bind(_ completion: @escaping Listener<T>) {
        listener = completion
        listener?(value)
    }
}
