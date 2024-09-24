import UIKit
import ProgressHUD

protocol CheckoutViewProtocol: AnyObject {
    func updateCurrencies(_ currencies: [CurrencyModel])
    func showHud()
    func removeHud()
}

final class CheckoutView: UIView {
    private lazy var currenciesCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .clear
        collection.allowsMultipleSelection = false
        collection.register(CurrencyCell.self)
        return collection
    }()
    
    private lazy var payView: PayView = {
        let view = PayView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            payView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            payView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            payView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            currenciesCollection.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            currenciesCollection.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            currenciesCollection.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            currenciesCollection.bottomAnchor.constraint(equalTo: payView.topAnchor)
        ])
    }
    
    private func setupView() {
        self.backgroundColor = .yaWhite
        
        [
            payView,
            currenciesCollection
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        self.addSubview(payView)
        self.addSubview(currenciesCollection)
    
        setupConstraints()
    }
    
    func setDelegate(_ delegate: CheckoutViewController) {
        currenciesCollection.delegate = delegate
        currenciesCollection.dataSource = delegate
        payView.delegate = delegate
    }
    
}

extension CheckoutView: CheckoutViewProtocol {
    func updateCurrencies(_ currencies: [CurrencyModel]) {
        currenciesCollection.reloadData()
    }
    
    func showHud() {
//        ProgressHUD.show()
    }
    
    func removeHud() {
//        ProgressHUD.dismiss()
    }
}
