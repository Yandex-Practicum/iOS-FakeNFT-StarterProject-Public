import Foundation
import FakeNFT

final class NFTNetworkCartServiceSpy: NFTNetworkCartService {
    var didGetNFTCalled = false
    var nftItemModel: NFTItemModel?

    func getNFTItemBy(
        id: String,
        result: @escaping FakeNFT.ResultHandler<FakeNFT.NFTItemModel>
    ) {
        self.didGetNFTCalled = true
        let nftItemModel = NFTItemModel(
            id: "1",
            createdAt: Date(),
            name: "asd",
            images: ["asd"],
            rating: 1,
            description: "as",
            price: 1,
            author: "asd"
        )

        self.nftItemModel = nftItemModel

        result(.success(nftItemModel))
    }
}
