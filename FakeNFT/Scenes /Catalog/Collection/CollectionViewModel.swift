import Foundation

final class CollectionViewModel: NSObject {
    let collection: NFTsCollectionNetworkModel
    
    var user: User?
    
    var reloadData: (() -> Void)?
    
    init(collection: NFTsCollectionNetworkModel) {
        self.collection = collection
        super .init()
        fetchUserData(by: collection.author)
    }
    
    func fetchUserData(by id: String) {
        DefaultNetworkClient().send(request: UserIdRequest(userId: id), type: UserNetworkModel.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.user = User(with: data)
                DispatchQueue.main.async { [weak self] in
                    self?.reloadData?()
                }
            case .failure(let error):
                print("Error status \(error)")
            }
        }
    }
}
