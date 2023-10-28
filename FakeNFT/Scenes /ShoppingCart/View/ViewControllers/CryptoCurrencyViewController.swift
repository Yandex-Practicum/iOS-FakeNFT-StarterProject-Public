import UIKit

class CryptoCurrencyViewController: UIViewController {
    
    private var selectedCryptocurrency: Cryptocurrency?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите способ оплаты"
        label.font = .bodyBold
        label.textColor = .textOnSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let imageButton = UIImage(systemName: "chevron.backward")?
            .withTintColor(.ypBlack ?? .black)
            .withRenderingMode(.alwaysOriginal)
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var paymentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оплатить", for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .bodyBold
        button.addTarget(self, action: #selector(paymentProceed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var upperPaymentText: UILabel = {
        let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.font = .caption2
        label.textColor = .textOnSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lowerPaymentText: UILabel = {
        let label = UILabel()
        label.text = "Пользовательского соглашения"
        label.font = .caption2
        label.textColor = .ypBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(lowerPaymentTextTapped))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PaymentCell.self, forCellWithReuseIdentifier: PaymentCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupTopLine()
        setupCollectionView()
        setupPaymentView()
    }
    
    private func setupTopLine() {
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9)
        ])
    }
    
    private func setupPaymentView() {
        view.addSubview(paymentView)
        view.addSubview(paymentButton)
        view.addSubview(upperPaymentText)
        view.addSubview(lowerPaymentText)
        
        NSLayoutConstraint.activate([
            
            paymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            paymentView.heightAnchor.constraint(equalToConstant: 186),
            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            paymentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            paymentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            paymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 60),
            
            upperPaymentText.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
            upperPaymentText.heightAnchor.constraint(equalToConstant: 18),
            upperPaymentText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            upperPaymentText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            lowerPaymentText.topAnchor.constraint(equalTo: upperPaymentText.bottomAnchor, constant: 0),
            lowerPaymentText.bottomAnchor.constraint(equalTo: paymentButton.topAnchor, constant: -16),
            lowerPaymentText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lowerPaymentText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 205)
        ])
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func paymentProceed() {
        let purchaseResultViewController: PurchaseResultViewController
        if selectedCryptocurrency != nil {
            purchaseResultViewController = PurchaseResultViewController(purchaseWasCompleted: true)
        } else {
            purchaseResultViewController = PurchaseResultViewController(purchaseWasCompleted: false)
        }
        purchaseResultViewController.modalPresentationStyle = .fullScreen
        present(purchaseResultViewController, animated: true, completion: nil)
    }
    
    @objc private func lowerPaymentTextTapped() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") else {
            return
        }
        
        let webViewController = WebViewController(url: url)
        let navController = UINavigationController(rootViewController: webViewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
}

extension CryptoCurrencyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Cryptocurrency.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCell.reuseIdentifier, for: indexPath) as? PaymentCell else {
            return UICollectionViewCell()
        }
        
        let cryptocurrency = Cryptocurrency(rawValue: indexPath.item)
        
        cell.topTextLabel.text = cryptocurrency?.fullName
        cell.bottomTextLabel.text = cryptocurrency?.abbreviation
        cell.iconImageView.image = UIImage(named: cryptocurrency!.fullName)
        return cell
    }
    
}

extension CryptoCurrencyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing = 7
        return CGSize(width: (Int(collectionView.bounds.width) - itemSpacing) / 2, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCryptocurrency = Cryptocurrency(rawValue: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedCryptocurrency = nil
    }
}

enum Cryptocurrency: Int, CaseIterable {
    case bitcoin
    case dogecoin
    case tether
    case apecoin
    case solana
    case ethereum
    case cardano
    case shibaInu
    
    var fullName: String {
        switch self {
        case .bitcoin:
            return "Bitcoin"
        case .dogecoin:
            return "Dogecoin"
        case .tether:
            return "Tether"
        case .apecoin:
            return "Apecoin"
        case .solana:
            return "Solana"
        case .ethereum:
            return "Ethereum"
        case .cardano:
            return "Cardano"
        case .shibaInu:
            return "Shiba Inu"
        }
    }
    
    var abbreviation: String {
        switch self {
        case .bitcoin:
            return "BTC"
        case .dogecoin:
            return "DOGE"
        case .tether:
            return "USDT"
        case .apecoin:
            return "APE"
        case .solana:
            return "SOL"
        case .ethereum:
            return "ETH"
        case .cardano:
            return "ADA"
        case .shibaInu:
            return "SHIB"
        }
    }
}
