import SwiftUI

struct Nft: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let images: [String]
    let description: String
    let rating: Int
    let price: Double
    let author: String
}
