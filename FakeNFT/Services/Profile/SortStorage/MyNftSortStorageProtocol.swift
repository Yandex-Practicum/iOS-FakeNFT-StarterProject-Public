import Foundation

protocol MyNftSortStorageProtocol {
    func saveSorting(_ descriptor: SortingOption)
    func fetchSorting() -> SortingOption?
}
