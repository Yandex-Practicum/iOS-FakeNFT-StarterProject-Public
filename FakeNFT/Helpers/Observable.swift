import Foundation

@propertyWrapper
final class Observable<Value> {
    private var onChange: ((Value) -> Void)?

    var wrappedValue: Value {
        didSet {
            onChange?(wrappedValue)
        }
    }

    var projectedValue: Observable<Value> {
        return self
    }

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    func bind(executeInitially: Bool = true, action: @escaping (Value) -> Void) {
        self.onChange = action
        if executeInitially {
            onChange?(wrappedValue)
        }
    }

    func unbind() {
        onChange = nil
    }
}
