//
//  ProfileModel.swift
//  FakeNFT
//

import Foundation

struct ProfileModel: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [Int]
    let likes: String

    static let defaultProfile = ProfileModel(name: "Joaquin Phoenix",
                                             avatar: "",
                                             description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
                                             website: "Joaquin Phoenix.com",
                                             nfts: [],
                                             likes: "")
}
