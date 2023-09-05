import Foundation

final class CollectionViewModel: NSObject {
    private (set) var model: CollectionModel?
    
    var reloadData: (() -> Void)?
    
    init(collection: NFTsCollectionCatalogModel) {
        self.model = CollectionModel(user: self.model?.user, collection: collection)
        super.init()
        fetchUserData(by: collection.author)
    }
    
    func fetchUserData(by id: String) {
        DefaultNetworkClient().send(request: UserIdRequest(userId: id), type: UserModel.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.model = CollectionModel(user: User(with: data), collection: self?.model?.collection)
                DispatchQueue.main.async {
                    self?.reloadData?()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
