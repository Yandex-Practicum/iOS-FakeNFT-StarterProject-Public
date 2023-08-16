import Foundation

struct Currency: Decodable {
    let id: String
    let title: String
    let name: String
    let image: String
}

typealias CurrenciesResult = [Currency]
