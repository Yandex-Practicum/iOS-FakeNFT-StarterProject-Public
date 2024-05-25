import Foundation

protocol NftNetworkStorage: AnyObject {
    func saveNft(_ nft: NftModel)
    func getNft(with id: String) -> NftModel?
}

final class NftNetworkStorageImpl: NftNetworkStorage {
    private var storage: [String: NftModel] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nftNetwork-queue")

    func saveNft(_ nft: NftModel) {
        DispatchQueue.main.async {
            self.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> NftModel? {
        DispatchQueue.global(qos: .userInitiated).sync {
            return storage[id]
        }
    }
}
