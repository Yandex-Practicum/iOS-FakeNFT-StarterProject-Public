import Foundation

struct CurrencyModel: Codable {
    let title: String
    let name: String
    let image: URL
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case name
        case image
        case id
    }
}
