import Foundation

protocol CurrencyStorage: AnyObject {
    func saveCurrency(_ currency: CurrencyModel)
    func getCurrency(with id: String) -> CurrencyModel?
}

final class CurrencyStorageImpl: CurrencyStorage {
    private var storage: [String: CurrencyModel] = [:]

    private let syncQueue = DispatchQueue(label: "sync-cart-queue")

    func saveCurrency(_ currency: CurrencyModel) {
        syncQueue.async { [weak self] in
            self?.storage[currency.id] = currency
        }
    }

    func getCurrency(with id: String) -> CurrencyModel? {
        syncQueue.sync {
            storage[id]
        }
    }
}
