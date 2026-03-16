import Foundation

final class CatalogNetworkProvider: CatalogProviderProtocol {
    private let service: CatalogsService

    init(service: CatalogsService) {
        self.service = service
    }

    func loadCatalog(completion: @escaping (Result<[Catalog], Error>) -> Void) {
        service.loadCatalogs(page: 0, size: 50, sortBy: nil, completion: completion)
    }
}

