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
    private var users: [User] = []

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
            self?.users = users
        }
    }

    func getUser(with id: String) -> User? {
        syncQueue.sync {
            users.first { $0.id == id }
        }
    }

    func saveUser(_ user: User) {
        syncQueue.async { [weak self] in
            guard let self else { return }
            if let index = self.users.firstIndex(where: { $0.id == user.id }) {
                self.users[index] = user
            } else {
                self.users.append(user)
            }
        }
    }
}
