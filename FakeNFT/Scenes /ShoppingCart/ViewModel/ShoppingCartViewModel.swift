import UIKit

final class ShoppingCartViewModel {
    @Observable
    var NFTModels: [ShoppingCartNFTModel] = []
    
    private let model: ShoppingCartContentLoader
    
    init(model: ShoppingCartContentLoader) {
        self.model = model
    }
    
    func viewDidLoad() {
        model.loadNFTs { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                
                switch result {
                case let .success(models):
                    let viewModelModels = models.map(ShoppingCartNFTModel.init(serverModel:))
                    self.NFTModels = viewModelModels
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    func didDeleteNFT(index: Int) {
        NFTModels.remove(at: index)
        
        model.removeFromCart(id: "1", nfts: NFTModels.map { $0.id }) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                switch result {
                case let .success(models):
                    print("Success")
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    func sortByPrice() {
        NFTModels.sort { $0.price < $1.price }
    }
    
    func sortByRating() {
        NFTModels.sort { $0.rating > $1.rating }
    }
    
    func sortByName() {
        NFTModels.sort { $0.name < $1.name }
    }
}
