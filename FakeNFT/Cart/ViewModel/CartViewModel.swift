import UIKit

protocol CodeInputViewModelProtocol {
    func didLoad()
    var NFTModels: [NFTModel]  {get set}
    func deleteFromCart(index: Int)
}

final class CartViewModel: CodeInputViewModelProtocol {
    @Observable
    var NFTModels: [NFTModel] = []
    
    private let model: CartLoadServiceProtocol
    
    init(model: CartLoadServiceProtocol = CartLoadService()) {
        self.model = model
    }
    
    func didLoad() {
        model.fetchNft { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                switch result {
                case let .success(models):
                    let viewModelModels = models.map(NFTModel.init(model:))
                    self.NFTModels = viewModelModels
                    print(self.NFTModels)
                    print("IM HERE TOO")
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    func deleteFromCart(index: Int) {
        NFTModels.remove(at: index)
        model.removeFromCart(id: "1", nfts: NFTModels.map{ $0.id}) { result in
            DispatchQueue.main.async { [weak self] in
                guard self != nil else  { return }
                switch result {
                case let .success(models):
                    print("NICE")
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}
