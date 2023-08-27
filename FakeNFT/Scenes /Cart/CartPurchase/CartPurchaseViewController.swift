import UIKit

final class CartPurchaseViewController: UIViewController {
    
    private let purchaseTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Bold.size17
        label.textColor = .label
        label.backgroundColor = .systemBackground
        label.textAlignment = .center
        label.text = "Выберите способ оплаты"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currencyCollectionView: UICollectionView = {
        
    }
    
}
