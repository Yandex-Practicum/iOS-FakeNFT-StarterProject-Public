import UIKit

protocol CartViewModelProtocol {
    func didLoad()
    var nfts: [NFTModel]  { get }
    var nftInfo: NFTInfo { get }
    var formattedPrice: NumberFormatter { get }
    var nftsObservable: Observable<[NFTModel]> { get }
}

final class CartViewModel: CartViewModelProtocol {
    
    @Observable
    var nfts: [NFTModel] = []
    
    var nftInfo: NFTInfo {
        let price = nfts.reduce(0.0) { $0 + $1.price}
        return NFTInfo(count: nfts.count, price: price)
    }
    
    var nftsObservable: Observable<[NFTModel]> { $nfts }
    
    private let cartLoadService: CartLoadServiceProtocol
    
    init(model: CartLoadServiceProtocol = CartLoadService()) {
        self.cartLoadService = model
    }
    
    var formattedPrice: NumberFormatter = {
        let formatted = NumberFormatter()
        formatted.locale = Locale(identifier: "ru_RU")
        formatted.numberStyle = .decimal
        return formatted
    }()
    
    func didLoad() {
        cartLoadService.fetchNft { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                switch result {
                case let .success(models):
                    let viewModelModels = models.map(NFTModel.init(model:))
                    self.nfts = viewModelModels
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}
