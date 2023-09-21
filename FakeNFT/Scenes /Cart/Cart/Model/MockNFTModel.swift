import UIKit

class MockNFT {
    static var nfts: [MockNFTModel] = [
        MockNFTModel(id: UUID(),
                     name: "April",
                     price: 1.78,
                     rating: 5,
                     image: UIImage(named: "mockImageNft") ?? .add),
        MockNFTModel(id: UUID(),
                     name: "April",
                     price: 1.78,
                     rating: 2,
                     image: UIImage(named: "mockImageNft") ?? .add),
        MockNFTModel(id: UUID(),
                     name: "April",
                     price: 1.78,
                     rating: 4,
                     image: UIImage(named: "mockImageNft") ?? .add)
    ]
}

struct MockNFTModel: Hashable {
    let id: UUID
    let name: String
    let price: Float
    let rating: Int
    let image: UIImage
}
