import UIKit

protocol CartViewModelProtocol {
    var nfts: [NFTModel]  { get }
    var isLoading: Bool { get }
    var nftInfo: NFTInfo { get }
    var formattedPrice: NumberFormatter { get }
    var nftsObservable: Observable<[NFTModel]> { get }
    var isLoadingObservable: Observable<Bool> { get }
    func didLoad()
}

final class CartViewModel: CartViewModelProtocol {
    
    @Observable
    private (set) var nfts: [NFTModel] = []
    
    @Observable
    private (set) var isLoading: Bool = true
    
    var nftInfo: NFTInfo {
        let price = nfts.reduce(0.0) { $0 + $1.price}
        return NFTInfo(count: nfts.count, price: price)
    }
    
    var nftsObservable: Observable<[NFTModel]> { $nfts }
    
    var isLoadingObservable: Observable<Bool> { $isLoading }
    
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
        isLoading = true
        cartLoadService.fetchNft { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.isLoading = false
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
