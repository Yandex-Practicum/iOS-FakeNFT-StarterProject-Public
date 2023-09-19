import UIKit

protocol CartViewModelProtocol {
    var nfts: [NFTModel]  { get }
    var isLoading: Bool { get }
    var nftInfo: NFTInfo { get }
    var formattedPrice: NumberFormatter { get }
    var nftsObservable: Observable<[NFTModel]> { get }
    var isLoadingObservable: Observable<Bool> { get }
    var updatedNfts: [String] { get }
    func didLoad()
    func deleteNFT(_ nft: NFTModel, completion: @escaping () -> Void)
    func didDeleteNFT(index: Int)
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
    
    var updatedNfts: [String] = [] {
        didSet {
            self.nfts = []
            
        }
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
    
    func deleteNFT(_ nft: NFTModel, completion: @escaping () -> Void) {
        let updateNft = updatedNfts.filter { $0 != nft.id }
        cartLoadService.updateNft(nfts: updateNft) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(updatedNfts):
                    self.updatedNfts = updatedNfts.nfts
                    self.nfts = self.nfts.filter { updateNft.contains($0.id)}
                    completion()
                    print(updatedNfts)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    func didDeleteNFT(index: Int) {
        nfts.remove(at: index)
        cartLoadService.removeFromCart(id: "1", nfts: nfts.map { $0.id }) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("done")
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}
