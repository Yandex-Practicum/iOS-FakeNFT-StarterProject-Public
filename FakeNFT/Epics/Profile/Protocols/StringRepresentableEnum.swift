import Foundation

protocol StringRepresentableEnum: RawRepresentable where RawValue == String {
    var stringValue: String { get }
}
