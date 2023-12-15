import Foundation

protocol NftStorage: AnyObject {
    func saveNft(_ nft: Nft)
    func getNft(with id: String) -> Nft?
    func saveUsers(_: [User])
    func getUser(with id: String) -> User?
    func saveUser(_: User)
}

// Пример простого класса, который сохраняет данные из сети
final class NftStorageImpl: NftStorage {
    private var storage: [String: Nft] = [:]
    private var users: [String: User] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: Nft) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> Nft? {
        syncQueue.sync {
            storage[id]
        }
    }

    func saveUsers(_ users: [User]) {
        syncQueue.async { [weak self] in
            users.forEach { user in
                self?.users[user.id] = user
            }
        }
    }

    func getUser(with id: String) -> User? {
        syncQueue.sync {
            users[id]
        }
    }

    func saveUser(_ user: User) {
        syncQueue.async { [weak self] in
            self?.users[user.id] = user
        }
    }
}
