import SwiftUI

struct Nft: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let images: [String]
    let description: String
    let rating: Int
    let price: Double
    let author: String
    
    static var mock: Self {
        .init(id: "", name: "Blue", images: ["blueSomething"], description: "", rating: 3, price: 1.78, author: "")
    }
}
