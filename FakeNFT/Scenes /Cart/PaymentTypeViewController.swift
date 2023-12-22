import UIKit

final class PaymentTypeViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    private let currencyImagesArray: [UIImage?] = [CurrencyAssets.bitcoinImage, CurrencyAssets.dogecoinImage, CurrencyAssets.tetherImage, CurrencyAssets.apecoinImage, CurrencyAssets.solanaImage, CurrencyAssets.etheriumImage, CurrencyAssets.cardanoImage, CurrencyAssets.shibaInuImage]
    
    private let currencyNamesArray: [String] = ["Bitcoin", "Dogecoin", "Tether", "Apecoin", "Solana", "Etherium", "Cardano", "Shiba Inu"]
    
    private let currency = [Currency]()
    
    // MARK: - Computed Properties
    
    private lazy var paymentLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .nftLightGray
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оплатить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.nftWhite, for: .normal)
        button.backgroundColor = .nftBlack
        button.layer.cornerRadius = 16
        button.addTarget(nil, action: #selector(paymentButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .nftGreenUniversal
        label.textAlignment = .left
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .nftWhite
        
        addSubviews()
        constraintsSetup()
        navBarSetup()
    }
    
    // MARK: - Private methods
    
    private func navBarSetup() {
        if (navigationController?.navigationBar) != nil {
            title = "Выберите способ оплаты"
            
            let backButton = UIButton(type: .custom)
            backButton.setImage(UIImage(named: "chevronBackward"), for: .normal)
            backButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
            
            let imageBarButtonItem = UIBarButtonItem(customView: backButton)
            self.navigationItem.leftBarButtonItem = imageBarButtonItem
        }
    }
    
    private func addSubviews() {
        view.addSubview(paymentLayerView)
        
        paymentLayerView.addSubview(paymentButton)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            paymentLayerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            paymentLayerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            paymentLayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paymentLayerView.heightAnchor.constraint(equalToConstant: 186),
            
            paymentButton.leadingAnchor.constraint(equalTo: paymentLayerView.leadingAnchor, constant: 16),
            paymentButton.trailingAnchor.constraint(equalTo: paymentLayerView.trailingAnchor, constant: -16),
            paymentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Handlers
    
    @objc func backButtonDidTap() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func paymentButtonDidTap() {
        //TODO: add code to proceed payment
    }
}
