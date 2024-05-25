import Foundation

protocol NftStorage: AnyObject {
    func saveNft(_ nft: NFT)
    func getNft(with id: String) -> NFT?
}

// Пример простого класса, который сохраняет данные из сети
final class NftStorageImpl: NftStorage {
    private var storage: [String: NFT] = [:]
    
    private let syncQueue = DispatchQueue(label: "sync-nft-queue")
    
    func saveNft(_ nft: NFT) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }
    
    func getNft(with id: String) -> NFT? {
        syncQueue.sync {
            storage[id]
        }
    }
}
