import Foundation

//MARK: - CollectionOfNftFabric
final class CollectionOfNftFabric {
    
    private let mockData = MockData.shared
    private var nfts: [NftModel]
    
    init() {
        nfts = mockData.collectionOfNft
    }
    
    func getNftsCount() -> Int {
        
        nfts.count
    }
    
    func getNft(by index: Int) -> NftModel {
        let nft = mockData.collectionOfNft[index]
        return nft
    }
}
