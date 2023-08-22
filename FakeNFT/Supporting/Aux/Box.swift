import Foundation

// Reference - https://www.kodeco.com/6733535-ios-mvvm-tutorial-refactoring-from-mvc

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
