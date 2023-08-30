import Foundation

struct Currency: Decodable {
    let title: String
    let name: String
    let image: String
    let id: String
}

typealias Currencies = [Currency]
