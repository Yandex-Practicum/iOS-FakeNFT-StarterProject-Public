//
//  GenericStorage.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 24.07.2023.
//

import Foundation
import Combine

final class GenericStorage<T: Hashable> {
    var dataPublisher: AnyPublisher<[T], Never> {
        return storedValueSubject.eraseToAnyPublisher()
    }
    
    private var storedValue: [T] = [] {
        didSet {
            storedValueSubject.send(storedValue)
        }
    }
    
    private var storedValueSubject = CurrentValueSubject<[T], Never>([])
    
    func add(_ item: T) {
        storedValue.append(item)
    }
    
    func delete(_ item: T?) {
        item != nil ? storedValue.removeAll(where: { $0 == item }) : storedValue.removeAll()
        
    }
}
