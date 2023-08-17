import Foundation

public struct Currency: Decodable {
    let id: String
    let title: String
    let name: String
    let image: String
}

public typealias CurrenciesResult = [Currency]
