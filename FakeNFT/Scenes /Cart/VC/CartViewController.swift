import UIKit

final class CartViewController: UIViewController {
    
    private var addedNFTs: [NFT] = []
    private var totalPrice: Float = 0
    
    // Элементы NFT - корзины
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NFTCell.self, forCellReuseIdentifier: NFTCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.font = .bodyBold
        label.textColor = .textOnSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Элементы для нижней панели оплаты
    
    private lazy var paymentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(addedNFTs.count)" + " NFT"
        label.font = .caption1
        label.textColor = .textOnSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        let formattedPrice = String(format: "%.2f", totalPrice)
        label.text = formattedPrice + " ETH"
        label.font = .bodyBold
        label.textColor = .ypGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("К оплате", for: .normal)
        button.backgroundColor = .ypBlack
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .bodyBold
        button.addTarget(self, action: #selector(toPaymentMethod), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Работа экрана

    override func viewDidLoad() {
        super.viewDidLoad()
        addedNFTs = MockCartData.nfts
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addedNFTs = MockCartData.nfts
        setupView()
    }
    
    private func setupView() {
        
        if addedNFTs.isEmpty {
            setupEmptyView()
        } else {
            setupNavBar()
            emptyLabel.isHidden = true
            totalPrice = countPrice(addedNFTs)
            setupTableView()
            setupPaymentView()
        }
    }
    
    private func setupNavBar() {
        if let navBar = navigationController?.navigationBar {
            // Creating a button with a picture
            let sortButton = UIButton(type: .custom)
            sortButton.setImage(UIImage(named: "navSortButton"), for: .normal)
            sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
            sortButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

            let imageBarButtonItem = UIBarButtonItem(customView: sortButton)

            navBar.topItem?.setRightBarButton(imageBarButtonItem, animated: false)
        }
    }

    @objc private func sortButtonTapped() {
        // Processing of clicking a button with a picture
    }

    private func setupEmptyView() {
        emptyLabel.isHidden = false
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 240),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isUserInteractionEnabled = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    private func setupPaymentView() {
        // Adding elements for the lower payment panel
        view.addSubview(paymentView)
        paymentView.addSubview(nftCountLabel)
        paymentView.addSubview(totalPriceLabel)
        paymentView.addSubview(paymentButton)
        
        NSLayoutConstraint.activate([
            paymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -83),
            paymentView.heightAnchor.constraint(equalToConstant: 76),
            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nftCountLabel.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
            nftCountLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            nftCountLabel.widthAnchor.constraint(equalToConstant: 79),
            nftCountLabel.heightAnchor.constraint(equalToConstant: 20),
            
            totalPriceLabel.topAnchor.constraint(equalTo: nftCountLabel.bottomAnchor, constant: 2),
            totalPriceLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            totalPriceLabel.widthAnchor.constraint(equalToConstant: 79),
            totalPriceLabel.heightAnchor.constraint(equalToConstant: 22),
            
            paymentButton.centerYAnchor.constraint(equalTo: paymentView.centerYAnchor),
            paymentButton.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 44),
            paymentButton.widthAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    private func countPrice(_ nftArray: [NFT]) -> Float {
        var totalPrice: Float = 0
        for nft in nftArray {
            totalPrice += nft.price
        }
        return totalPrice
    }
    
    @objc private func toPaymentMethod() {
        let cryptoCurrencyViewController = CryptoCurrencyViewController()
        cryptoCurrencyViewController.modalPresentationStyle = .fullScreen
        present(cryptoCurrencyViewController, animated: true, completion: nil)
    }
}

// Реализация UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedNFTs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTCell.reuseIdentifier, for: indexPath) as? NFTCell else {
            return UITableViewCell()
        }
        let nft = addedNFTs[indexPath.row]
        cell.backgroundColor = .white
        cell.configure(with: nft)
        return cell
    }
}

// Реализация UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140 
    }
}
