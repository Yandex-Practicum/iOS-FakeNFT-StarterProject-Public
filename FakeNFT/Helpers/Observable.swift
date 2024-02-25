import Foundation

@propertyWrapper
final class Observable<Value> {
	var wrappedValue: Value {
		didSet {
			onChange?(wrappedValue)
		}
	}
	
	var projectedValue: Observable<Value> {
		return self
	}
	
	private var onChange: ((Value) -> Void)? = nil
	
	init(wrappedValue: Value) {
		self.wrappedValue = wrappedValue
	}
	
	func bind(action: @escaping (Value) -> Void) {
		self.onChange = action
	}
}
