import Foundation

//MARK: - Protocol
protocol NftCellFabricProtocol {
    
    func getAvatar() -> URL?
    func getRating() -> Int
    func getName() -> String
    func getCost() -> String
}

//MARK: - NftCellFabric
final class NftCellFabric {
    
    private var nft: NftModel
    
    init(nft: NftModel) {
        self.nft = nft
    }
}

//MARK: - NftCellFabricProtocol
extension NftCellFabric: NftCellFabricProtocol {
    
    func getNft() -> NftModel {
        
        return nft
    }
    
    func getAvatar() -> URL? {
        
        nft.images[0]
    }
    
    func getRating() -> Int {
        
        nft.rating
    }
    
    func getName() -> String {
        
        nft.name
    }
    
    func getCost() -> String {
        
        ("\(nft.rating) ETH")
    }
}

//MARK: - NftCellDelegate
extension NftCellFabric: NftCellDelegate {
    
    func isLiked() -> Bool {
        false
    }
    
    func isOnBasket() -> Bool {
        false
    }
}
