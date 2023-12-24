import Foundation

protocol ProfileStorageProtocol: AnyObject {
    func saveProfile(_ profile: ProfileModelNetwork)
    func getProfile() -> ProfileModelNetwork?
}

final class ProfileStorage: ProfileStorageProtocol {
    private var profile: ProfileModelNetwork?

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveProfile(_ profile: ProfileModelNetwork) {
        syncQueue.async { [weak self] in
            self?.profile = profile
        }
    }

    func getProfile() -> ProfileModelNetwork? {
        syncQueue.sync { [weak self] in
            return self?.profile
        }
    }
}
