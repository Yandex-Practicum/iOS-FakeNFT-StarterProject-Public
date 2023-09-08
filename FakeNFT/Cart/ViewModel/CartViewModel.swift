import UIKit

protocol CodeInputViewModelProtocol {
    func didLoad()
    var nfts: [NFTModel]  { get }
    var nftInfo: NFTInfo { get }
    func deleteFromCart(index: Int)
}

final class CartViewModel: CodeInputViewModelProtocol {
    
    
    @Observable
    var nfts: [NFTModel] = []
    
    var nftInfo: NFTInfo {
        let price = nfts.reduce(0.0) { $0 + $1.price}
        return NFTInfo(count: nfts.count, price: price)
    }
    
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
                    self.nfts = viewModelModels
                    print(self.nfts)
                    print("IM HERE TOO")
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    func deleteFromCart(index: Int) {
        nfts.remove(at: index)
        model.removeFromCart(id: "1", nfts: nfts.map{ $0.id}) { result in
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
