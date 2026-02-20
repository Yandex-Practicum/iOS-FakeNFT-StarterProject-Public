typealias CatalogsCompletion = (Result<[Catalog], Error>) -> Void

protocol CatalogsService {
    func loadCatalogs(page: Int, size: Int, sortBy: String?, completion: @escaping CatalogsCompletion)
    func loadCatalog(id: String, completion: @escaping (Result<Catalog, Error>) -> Void)
}

final class CatalogsServiceImpl: CatalogsService {
    private let client: NetworkClient
    init(client: NetworkClient) { self.client = client }

    func loadCatalogs(page: Int, size: Int, sortBy: String?, completion: @escaping CatalogsCompletion) {
        let request = CatalogsListRequest(dto: PageDto(page: page, size: size, sortBy: sortBy))
        client.send(request: request, type: [Catalog].self, onResponse: completion)
    }

    func loadCatalog(id: String, completion: @escaping (Result<Catalog, Error>) -> Void) {
        let request = CatalogByIdRequest(id: id)
        client.send(request: request, type: Catalog.self, onResponse: completion)
    }
}

