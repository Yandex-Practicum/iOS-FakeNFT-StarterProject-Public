import Foundation

protocol UsersStorageProtocol: AnyObject {
    func saveUsers(_ users: [User])
}

final class UsersStorage: UsersStorageProtocol {
    
    private var storage = [User]()

    private let syncQueue = DispatchQueue(label: "sync-user-queue")
    
    func saveUsers(_ users: [User]) {
        syncQueue.async { [weak self] in
            self?.storage = users
        }
    }
}
