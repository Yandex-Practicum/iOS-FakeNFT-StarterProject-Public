import Foundation

struct NFT: Decodable {
    let id: String
    let images: [URL]
    let name: String
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let createdAt: String
}

extension NFT: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: NFT, rhs: NFT) -> Bool {
        lhs.id == rhs.id
    }
}
