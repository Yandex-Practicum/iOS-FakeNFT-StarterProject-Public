import Foundation

// MARK: - Nft
struct Nft: Codable {
    let createdAt: Date
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}

typealias Nfts = [Nft]
