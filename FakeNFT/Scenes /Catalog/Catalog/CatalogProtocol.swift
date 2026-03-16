import Foundation

protocol CatalogViewInput: AnyObject {
    func setLoading(_ isLoading: Bool)
    func showError(_ error: Error)
    func showCatalog(_ items: [Catalog])
}

protocol CatalogViewOutput: AnyObject {
    func viewDidLoad()
    func didTapSortByName()
    func didTapSortByCount()
    func didSelectItem(at index: Int)
}

protocol CatalogProviderProtocol {
    func loadCatalog(completion: @escaping (Result<[Catalog], Error>) -> Void)
}

protocol CatalogRouterInput: AnyObject {
    func openCollection(_ collection: Catalog)
}

