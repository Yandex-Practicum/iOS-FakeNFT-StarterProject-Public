import Foundation
protocol CartViewModelProtocol: AnyObject {
    var cartModels: [NFTCartModel] { get }
    var isPlaceholderHidden: Bool { get }
    var isTableViewHidden: Bool { get }
    func viewDidLoad(completion: @escaping () -> Void)
    func didDeleteNFT(at index: Int)
    func didSortByPrice()
    func didSortByRating()
    func didSortByName()
    func isCartEmpty()
}

final class CartViewModel: CartViewModelProtocol {
    @Observable
    var cartModels: [NFTCartModel] = []
    
    @Observable
    var isPlaceholderHidden: Bool = true
    
    @Observable
    var isTableViewHidden: Bool = true
    
    private let model: NFTCartManager
    
    init(model: NFTCartManager) {
        self.model = model
    }
    func viewDidLoad(completion: @escaping () -> Void) {
        UIBlockingProgressHUD.show()
        model.fetchNFTs { nfts in
            DispatchQueue.main.async { [weak self] in
                UIBlockingProgressHUD.dismiss()
                switch nfts {
                case .success(let models):
                    let viewModels = models.map(NFTCartModel.init(serverModel:))
                    self?.cartModels = viewModels
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func didDeleteNFT(at index: Int) {
        cartModels.remove(at: index)
        model.removeNFTFromCart(id: "1",
                                nfts: cartModels.map { $0.id }) { result in
            switch result {
            case .success(let order):
                print("\(order.id) successfully deleted")
            case .failure(let error):
                print("\(error.localizedDescription) couldn't delete")
            }
        }
    }
    
    func didSortByPrice() {
        cartModels.sort { $0.price > $1.price}
    }
    
    func didSortByRating() {
        cartModels.sort { $0.rating.rawValue > $1.rating.rawValue}
    }
    
    func didSortByName() {
        cartModels.sort { $0.name > $1.name }
    }
    
    func isCartEmpty() {
        if cartModels.isEmpty {
            isPlaceholderHidden = false
            return
        } else {
            isTableViewHidden = false
            isPlaceholderHidden = true
        }
    }
    func bindCart() {
        isCartEmpty()
        self.$cartModels.bind {[weak self] _ in
            self?.isCartEmpty()
        }
    }
}
