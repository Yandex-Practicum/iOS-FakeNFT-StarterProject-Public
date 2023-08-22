import Foundation

public struct Currency: Decodable {
    let id: String
    let title: String
    let name: String
    let image: String

    public init(id: String, title: String, name: String, image: String) {
        self.id = id
        self.title = title
        self.name = name
        self.image = image
    }
}

public typealias CurrenciesResult = [Currency]
