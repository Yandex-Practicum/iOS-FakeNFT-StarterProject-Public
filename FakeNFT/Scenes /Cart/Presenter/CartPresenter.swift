import UIKit

final class CartPresenter: CartPresenterProtocol {
    
    // MARK: - Stored Properties
    
    var visibleNFT: [CartNFTModel] = CartMockData.mockNFT {
        didSet {
            viewController?.tableViewUpdate()
        }
    }
    private weak var viewController: CartViewControllerProtocol?
    
    init(viewController: CartViewControllerProtocol?) {
        self.viewController = viewController
    }
    
    // MARK: - Public methods
    
    func sortByPrice() {
        visibleNFT.sort { $0.price > $1.price }
        UserDefaults.standard.set(true, forKey: "sortByPrice")
        UserDefaults.standard.removeObject(forKey: "sortByRating")
        UserDefaults.standard.removeObject(forKey: "sortByName")
    }
    
    func sortByRating() {
        visibleNFT.sort { $0.rating > $1.rating }
        UserDefaults.standard.set(true, forKey: "sortByRating")
        UserDefaults.standard.removeObject(forKey: "sortByPrice")
        UserDefaults.standard.removeObject(forKey: "sortByName")
    }
    
    func sortByName() {
        visibleNFT.sort { $0.name < $1.name }
        UserDefaults.standard.set(true, forKey: "sortByName")
        UserDefaults.standard.removeObject(forKey: "sortByPrice")
        UserDefaults.standard.removeObject(forKey: "sortByRating")
    }
    
    func deleteItemFormCart(for index: Int) {
        visibleNFT.remove(at: index)
    }
    
    func addItemToCart(_ nft: CartNFTModel) {
        visibleNFT.append(nft)
    }
    
    func cleanCart() {
        visibleNFT.removeAll()
    }
}
