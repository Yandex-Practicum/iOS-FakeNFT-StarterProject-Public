//
//  CartVMWrapper.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 20.06.2023.
//

@propertyWrapper
final class Observable<Value> {
    private var onChange: ((Value) -> Void)? = nil
    
    var wrappedValue: Value {
        didSet {
            onChange?(wrappedValue) // вызываем функцию после изменения обёрнутого значения
        }
    }
    
    var projectedValue: Observable<Value> { // возвращает экземпляр самого property wrapper
        return self
    }
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    func bind(action: @escaping (Value) -> Void) { // функция для добавления функции, вызывающей изменения
        self.onChange = action
    }
}
