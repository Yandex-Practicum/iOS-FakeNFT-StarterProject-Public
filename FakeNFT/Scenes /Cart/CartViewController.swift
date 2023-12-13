import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    private let mockNFTArray: [CartNFTModel] = CartMockData.mockNFT
    private var visibleNFT: [CartNFTModel]? {
        didSet {
            tableViewAndLabelsUpdate()
        }
    }
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Computed Properties
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .NFTBlack
        label.textAlignment = .center
        label.text = "Корзина пуста"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIndentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .NFTWhite
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var paymentLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .NFTLightGray
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 NFT"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .NFTBlack
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .NFTGreenUniversal
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.NFTWhite, for: .normal)
        button.backgroundColor = .NFTBlack
        button.layer.cornerRadius = 16
        button.addTarget(nil, action: #selector(paymentButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visibleNFT = mockNFTArray
        
        view.backgroundColor = .NFTWhite
        
        addSubviews()
        constraintsSetup()
        navBarSetup()
        tableViewAndLabelsUpdate()
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        view.addSubview(emptyLabel)
        view.addSubview(tableView)
        view.addSubview(paymentLayerView)
        
        paymentLayerView.addSubview(nftCountLabel)
        paymentLayerView.addSubview(totalPriceLabel)
        paymentLayerView.addSubview(paymentButton)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            paymentLayerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            paymentLayerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            paymentLayerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentLayerView.heightAnchor.constraint(equalToConstant: 76),
            
            nftCountLabel.leadingAnchor.constraint(equalTo: paymentLayerView.leadingAnchor, constant: 16),
            nftCountLabel.topAnchor.constraint(equalTo: paymentLayerView.topAnchor, constant: 16),
            nftCountLabel.heightAnchor.constraint(equalToConstant: 20),
            
            totalPriceLabel.leadingAnchor.constraint(equalTo: nftCountLabel.leadingAnchor),
            totalPriceLabel.topAnchor.constraint(equalTo: nftCountLabel.bottomAnchor, constant: 2),
            totalPriceLabel.heightAnchor.constraint(equalToConstant: 22),
            
            paymentButton.trailingAnchor.constraint(equalTo: paymentLayerView.trailingAnchor, constant: -16),
            paymentButton.leadingAnchor.constraint(equalTo: totalPriceLabel.trailingAnchor, constant: 24),
            paymentButton.centerYAnchor.constraint(equalTo: paymentLayerView.centerYAnchor),
            paymentButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func navBarSetup() {
        if let navBar = navigationController?.navigationBar {
            let sortButton = UIButton(type: .custom)
            sortButton.setImage(UIImage(named: "sortButton"), for: .normal)
            sortButton.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
            sortButton.addTarget(nil, action: #selector(sortButtonDidTap), for: .touchUpInside)
            
            let imageBarButtonItem = UIBarButtonItem(customView: sortButton)
            navBar.topItem?.setRightBarButton(imageBarButtonItem, animated: false)
        }
    }
    
    private func tableViewAndLabelsUpdate() {
        guard let visibleNFT else { return }
        nftCountLabel.text = "\(visibleNFT.count)" + " NFT"
        
        var totalPrice: Float = 0
        for nft in visibleNFT {
            totalPrice += nft.price
        }
        let formattedPrice = String(format: "%.2f", totalPrice)
        self.totalPriceLabel.text = formattedPrice + " ETH"
        
        tableView.reloadData()
    }
    
    // MARK: - Obj-C methods
    
    @objc func sortButtonDidTap() {
        //TODO: add code to sort items in cart
    }
    
    @objc func paymentButtonDidTap() {
        //TODO: add code to jump to PaymentViewController
    }
}

    // MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let visibleNFT else { return .zero }
        return visibleNFT.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIndentifier) as? CartTableViewCell,
              let visibleNFT = visibleNFT
        else { return UITableViewCell() }
        
        let nft = visibleNFT[indexPath.row]
        cell.configureCell(with: nft)
        
        return cell
    }
}

    // MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
