import Foundation

final class CatalogViewModel: NSObject {
    
    private (set) var collections: [NFTsCollectionNetworkModel] = []
    
    var reloadData: (() -> Void)?
    var loadingStarted: (() -> Void)?
    var loadingFinished: (() -> Void)?
    private let sorter = SortNFTsCollections()
    
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
    
    func sortByName() {
        collections = collections.sorted {
            $0.name < $1.name
        }
        sorter.setSortValue(value: SortNFTsCollectionType.byName.rawValue)
        reloadData?()
    }
    
    func sortByNFTsCount() {
        collections = collections.sorted {
            $0.nfts.count > $1.nfts.count
        }
        sorter.setSortValue(value: SortNFTsCollectionType.byNFTsCount.rawValue)
        reloadData?()
    }
}
