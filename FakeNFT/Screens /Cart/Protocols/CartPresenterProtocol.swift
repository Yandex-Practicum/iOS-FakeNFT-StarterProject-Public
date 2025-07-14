import Foundation

protocol CartPresenterProtocol: AnyObject {
    func setup()
    func sort(by option: SortOption)
}
