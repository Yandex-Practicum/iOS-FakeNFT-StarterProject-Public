import Foundation

final class CatalogViewModel: NSObject {
    
    private (set) var collections: [NFTsCollectionNetworkModel] = []
    
    var reloadData: (() -> Void)?
    var loadingStarted: (() -> Void)?
    var loadingFinished: (() -> Void)?
    
    override init() {
        super.init()
    }

    func updateData() {
        fetchData()
    }
    
    private func fetchData() {
        loadingStarted?()
        DefaultNetworkClient().send(request: CollectionRequest(), type: [NFTsCollectionNetworkModel].self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.collections = data
                DispatchQueue.main.async {
                    self?.loadingFinished?()
                    self?.reloadData?()
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
}
