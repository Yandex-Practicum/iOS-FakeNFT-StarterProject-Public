import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    private var presenter = CartPresenter()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var deleteIndex: Int?
    
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
        
        view.backgroundColor = .NFTWhite
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.layer.zPosition = 50
        
        addSubviews()
        constraintsSetup()
        navBarSetup()
        tableViewAndLabelsUpdate()
        elementsSetup()
        updateSorting()
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        view.addSubview(emptyLabel)
        view.addSubview(activityIndicator)
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
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
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
        if (navigationController?.navigationBar) != nil {
            let sortButton = UIButton(type: .custom)
            sortButton.setImage(UIImage(named: "sortButton"), for: .normal)
            sortButton.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
            sortButton.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)
            
            let imageBarButtonItem = UIBarButtonItem(customView: sortButton)
            self.navigationItem.rightBarButtonItem = imageBarButtonItem
        }
    }
    
    private func tableViewAndLabelsUpdate() {
        nftCountLabel.text = "\(presenter.visibleNFT.count)" + " NFT"
        
        var totalPrice: Float = 0
        for nft in presenter.visibleNFT {
            totalPrice += nft.price
        }
        let formattedPrice = String(format: "%.2f", totalPrice)
        self.totalPriceLabel.text = formattedPrice + " ETH"
        
        tableView.reloadData()
    }
    
    private func elementsSetup() {
        if presenter.visibleNFT.isEmpty {
            emptyLabel.isHidden = false
            tableView.isHidden = true
            paymentLayerView.isHidden = true
            
            navigationController?.navigationBar.isHidden = true
        } else {
            emptyLabel.isHidden = true
            tableView.isHidden = false
            paymentLayerView.isHidden = false
            
            navigationController?.navigationBar.isHidden = false
        }
        tabBarController?.tabBar.isHidden = false
    }
    
    private func updateSorting() {
        if UserDefaults.standard.value(forKey: "sortByPrice") != nil {
            presenter.sortByPrice()
        } else if UserDefaults.standard.value(forKey: "sortByRating") != nil {
            presenter.sortByRating()
        } else if UserDefaults.standard.value(forKey: "sortByName") != nil {
            presenter.sortByName()
        }
    }
    
    // MARK: - Obj-C methods
    
    @objc func sortButtonDidTap() {
        let alert = UIAlertController(title: nil, message: "Сортировка", preferredStyle: .actionSheet)
        
        let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { _ in
            self.presenter.sortByPrice()
            self.tableView.reloadData()
        }
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.presenter.sortByRating()
            self.tableView.reloadData()
        }
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { _ in
            self.presenter.sortByName()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alert.addAction(sortByPriceAction)
        alert.addAction(sortByRatingAction)
        alert.addAction(sortByNameAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func paymentButtonDidTap() {
        //TODO: add code to jump to PaymentViewController
    }
}

    // MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.visibleNFT.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIndentifier) as? CartTableViewCell
        else { return UITableViewCell() }
        
        let nft = presenter.visibleNFT[indexPath.row]
        cell.configureCell(with: nft)
        cell.cellIndex = indexPath.row
        cell.delegate = self
        
        return cell
    }
}

    // MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

    // MARK: - CartTableViewCellDelegate

extension CartViewController: CartTableViewCellDelegate {
    func showDeleteViewController(for index: Int, with image: UIImage) {
        let viewController = DeleteFromCartViewController(itemImage: image, itemIndex: index)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        viewController.delegate = self
        present(viewController, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
}

    // MARK: - DeleteFromCartViewControllerDelegate

extension CartViewController: DeleteFromCartViewControllerDelegate {
    func deleteItemFromCart(for index: Int) {
        presenter.deleteItemFormCart(for: index)
        tableViewAndLabelsUpdate()
        elementsSetup()
    }
    
    func showTabBar() {
        tabBarController?.tabBar.isHidden = false
    }
}
