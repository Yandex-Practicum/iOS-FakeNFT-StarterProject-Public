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
    private let sortOptionKey = "sortOption"
    private var items: [CartItemModel] = []
    
    init(cartService: CartServiceProtocol) {
        self.cartService = cartService
    }
    
    func sort (by option: SortOption ) {
        UserDefaults.standard.set(option.rawValue, forKey: sortOptionKey)
        
        switch option {
        case .name:
            items.sort { $0.title < $1.title}
        case .price:
            items.sort { $0.price < $1.price}
        case .rating:
            items.sort { $0.rating > $1.rating}
        }
        
        let model = CartScreenModel(items: items)
        view?.update(with: model)
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
            guard let self = self else {return}
            
            switch result {
            case .success(let model):
                self.items = model.items // про это ещё раз уточнить
                if let rawValue = UserDefaults.standard.string(forKey: self.sortOptionKey),
                   let sortOption = SortOption(rawValue: rawValue) {
                    self.sort(by: sortOption)
                } else {
                    self.view?.update(with: model)
                }
            case .failure(let error):
                print(error)
            }
            
            self.view?.hideProgressHUD()
        }
    }
}
