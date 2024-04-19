import Foundation

//MARK: - Protocol
protocol NftCellFabricProtocol {
    
    func getAvatar(with id: String) -> URL
    func getRating(with id: String) -> Int
    func getName(with id: String) -> String
    func getCost(with id: String) -> String
}

//MARK: - NftCellFabric
final class NftCellFabric {
    
    private let mockData = MockData.shared
    private var nft: NftModel
    
    init(nft: NftModel) {
        self.nft = nft
    }
    
    convenience init(with id: String) {
        let nft = MockData.shared.collectionOfNft.first { model in
            model.id == id
        }
        self.init(nft: nft!)
    }
}

//MARK: - NftCellFabricProtocol
extension NftCellFabric: NftCellFabricProtocol {
    
    func getNft(with id: String) -> NftModel {
        let nft = mockData.collectionOfNft.first { model in
            model.id == id
        }
        guard let nft = nft else { return mockData.collectionOfNft[0] }
        return nft
    }
    
    func getAvatar(with id: String) -> URL {
        nft.avatar
    }
    
    func getRating(with id: String) -> Int {
        nft.rating
    }
    
    func getName(with id: String) -> String {
        nft.name
    }
    
    func getCost(with id: String) -> String {
        ("\(Float(nft.rating)) ETH")
    }
}

//MARK: - NftCellDelegate
extension NftCellFabric: NftCellDelegate {
    
    func isLiked(with id: String) -> Bool {
        false
    }
    
    func isOnBasket(with id: String) -> Bool {
        false
    }
}
