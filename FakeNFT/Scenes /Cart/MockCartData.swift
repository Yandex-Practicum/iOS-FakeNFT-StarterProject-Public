import UIKit

class MockCartData {
    static var nfts: [NFT] = [
    NFT(id: UUID(),
        name: "April",
        picture: UIImage(named: "NFT1") ?? .checkmark,
        price: 4.54,
        rating: 4),
    
    NFT(id: UUID(),
        name: "Greena",
        picture: UIImage(named: "NFT2") ?? .checkmark,
        price: 4.54,
        rating: 4)
    ]
}
