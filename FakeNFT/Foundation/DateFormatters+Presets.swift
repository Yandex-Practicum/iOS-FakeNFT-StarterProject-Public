import Foundation

extension DateFormatter {
    // We use static var because creating a dateFormatter is an expensive operation and we should do it once
    static var defaultDateFormatter: ISO8601DateFormatter = .init()
}
