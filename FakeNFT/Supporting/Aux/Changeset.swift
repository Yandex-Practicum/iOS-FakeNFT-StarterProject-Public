import Foundation

public typealias ContentMatches<T: Equatable> = (T, T) -> Bool

public struct Changeset<T: Equatable> {
    var deletions: [IndexPath] = []
    var insertions: [IndexPath] = []
    var modifications: [IndexPath] = []

    public init(oldItems: [T], newItems: [T]) {
        guard !self.hasChanges(oldItems: oldItems, newItems: newItems) else {
            self.setupModifications(oldItems: oldItems)
            return
        }
        self.setupChangset(oldItems: oldItems, newItems: newItems)
    }
}

private extension Changeset {
    mutating func setupChangset(oldItems: [T], newItems: [T]) {
        let difference = newItems.difference(from: oldItems)

        for change in difference {
            switch change {
            case .remove(let offset, _, _):
                self.deletions.append(IndexPath(row: offset, section: 0))
            case .insert(let offset, _, _):
                self.insertions.append(IndexPath(row: offset, section: 0))
            }
        }
    }

    func hasChanges(oldItems: [T], newItems: [T]) -> Bool {
        let containedItems = oldItems.filter { newItems.contains($0) }

        let doesCapacityEqual = oldItems.count == newItems.count
        let doesNotHaveChanges = containedItems.isEmpty
        return doesCapacityEqual && doesNotHaveChanges
    }

    mutating func setupModifications(oldItems: [T]) {
        self.modifications = (0..<oldItems.count).map { IndexPath(row: $0, section: 0) }
    }
}
