import Foundation

@propertyWrapper
struct UserDefaultsManager<Value: StringRepresentableEnum> {
    let key: String
    let defaultValue: Value
    var storage: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            if let rawValue = storage.string(forKey: key) {
                return Value(rawValue: rawValue) ?? defaultValue
            }
            return defaultValue
        }
        set {
            storage.set(newValue.rawValue, forKey: key)
        }
    }
}


extension UserDefaultsManager where Value: Codable {
    var wrappedValue: Value {
        get {
            if
                let data = storage.value(forKey: key) as? Data,
                let value = try? JSONDecoder().decode(Value.self, from: data)
            { return value }
            return defaultValue
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                storage.set(data, forKey: key)
            }
        }
    }
}
