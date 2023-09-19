import Foundation

final class CatalogViewModel: NSObject {
    
    private (set) var collections: [NFTsCollectionNetworkModel] = []
    
    var reloadData: (() -> Void)?
    
    override init() {
        super.init()
        fetchData()
    }
    
    private func fetchData() {
        DefaultNetworkClient().send(request: CollectionRequest(), type: [NFTsCollectionNetworkModel].self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.collections = data
                DispatchQueue.main.async {
                    self?.reloadData?()
                }
            case.failure(let error):
                print(error)
            }
        }
    }
}
