import Foundation

public struct Order: Codable {
    let id: String
    let nfts: [String]

    public init(id: String, nfts: [String]) {
        self.id = id
        self.nfts = nfts
    }
}
