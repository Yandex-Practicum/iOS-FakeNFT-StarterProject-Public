import Foundation
//вынести протокол в отдельную папку
protocol CartPresenterProtocol: AnyObject {
    func setup()
    func sort(by option: SortOption)
}
// сейчас работа ведется с моковым сервисом 10.07 18:40
final class CartPresenter {
    
    weak var view: CartViewProtocol?
    private let cartService: CartServiceProtocol
    private var items: [CartItemModel] = []
    
    init(cartService: CartServiceProtocol) {
        self.cartService = cartService
    }
    
    func sort (by option: SortOption ) {
        switch option {
        case .name:
            items.sort { $0.title < $1.title}
        case .price:
            items.sort { $0.price < $1.price}
        case .rating:
            items.sort { $0.rating > $1.rating}
        }
        
        view?.display(items)
    }
    
    private func buildScreenModel(onResponse: @escaping (Result<CartScreenModel, Error>) -> Void) {
        cartService.getCartItems { result in
            switch result {
            case .success(let items):
                onResponse(.success(CartScreenModel(items: items)))
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
}

extension CartPresenter: CartPresenterProtocol {
    func setup() {
        view?.showProgressHUD()
        buildScreenModel {[weak self] result in
            switch result {
            case .success(let model):
                self?.view?.update(with: model)
            case .failure(let error):
                print(error)
            }
            
            self?.view?.hideProgressHUD()
        }
    }
}
