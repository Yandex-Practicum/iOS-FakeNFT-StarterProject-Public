import Foundation

final class CatalogViewModel: NSObject {
    
    private (set) var collections: [NFTsCollectionModel] = []
    
    var reloadData: (() -> Void)?
    
    override init() {
        super.init()
        fetchData()
    }
    
    private func fetchData() {
        DefaultNetworkClient().send(request: CollectionRequest(), type: [NFTsCollectionModel].self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.collections = data.map { NFTsCollectionModel(with: $0) }
                DispatchQueue.main.async {
                    self?.reloadData?()
                }
            case.failure(let error):
                print(error)
            }
        }
    }
}
