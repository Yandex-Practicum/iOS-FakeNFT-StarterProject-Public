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
    
    // Удаление НФТ
    
    private var indexDelete: Int? // Выбранный NFT для удаления
    
    lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.isHidden = true
        blurView.frame = UIScreen.main.bounds
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    let deleteText: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.numberOfLines = 0
        label.isHidden = true
        label.textAlignment = .center
        label.text = "Вы уверены, что хотите удалить объект из корзины?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.addTarget(self, action: #selector(deleteNFT), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cancelDeletion), for: .touchUpInside)
        button.setTitle("Вернуться", for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var iconDeleteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NFT1")
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
            hiddenCorrection()
        } else {
            tableView.reloadData()
            setupNavBar()
            totalPrice = countPrice(addedNFTs)
            setupTableView()
            setupPaymentView()
            hiddenCorrection()
        }
    }
    
    private func setupNavBar() {
        if let navBar = navigationController?.navigationBar {
            // Creating a button with a picture
            let sortButton = UIButton(type: .custom)
            sortButton.setImage(UIImage(named: "navSortButton"), for: .normal)
            sortButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            sortButton.addTarget(self, action: #selector(showSortingOptions), for: .touchUpInside)

            let imageBarButtonItem = UIBarButtonItem(customView: sortButton)

            navBar.topItem?.setRightBarButton(imageBarButtonItem, animated: false)
        }
    }

    private func setupEmptyView() {
        emptyLabel.isHidden = false
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isUserInteractionEnabled = true
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
        
        nftCountLabel.text = "\(addedNFTs.count)" + " NFT"
        let formattedPrice = String(format: "%.2f", totalPrice)
        totalPriceLabel.text = formattedPrice + " ETH"
        
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
    
    private func sortByPrice() {
        // Реализация сортировки по цене
        addedNFTs.sort { $0.price < $1.price }
        tableView.reloadData()
    }

    private func sortByRating() {
        // Реализация сортировки по рейтингу
        addedNFTs.sort { $0.rating > $1.rating }
        tableView.reloadData()
    }

    private func sortByName() {
        // Реализация сортировки по названию
        addedNFTs.sort { $0.name < $1.name }
        tableView.reloadData()
    }
    
    private func reloadViewAfterDelete() {
        tableView.reloadData()
        setupView()
        nftCountLabel.text = "\(addedNFTs.count)" + " NFT"
        let formattedPrice = String(format: "%.2f", totalPrice)
        totalPriceLabel.text = formattedPrice + " ETH"
    }
    
    private func hiddenCorrection() {
        if addedNFTs.isEmpty {
            navigationController?.isNavigationBarHidden = true
            paymentView.isHidden = true
            nftCountLabel.isHidden = true
            totalPriceLabel.isHidden = true
            paymentButton.isHidden = true
            emptyLabel.isHidden = false
        } else {
            navigationController?.isNavigationBarHidden = false
            paymentView.isHidden = false
            nftCountLabel.isHidden = false
            totalPriceLabel.isHidden = false
            paymentButton.isHidden = false
            emptyLabel.isHidden = true
        }
    }
    
    @objc private func showSortingOptions() {
        let actionSheet = UIAlertController(title: nil, message: "Сортировка", preferredStyle: .actionSheet)
        
        let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { _ in
            // Действие для сортировки по цене
            self.sortByPrice()
        }
        
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            // Действие для сортировки по рейтингу
            self.sortByRating()
        }
        
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { _ in
            // Действие для сортировки по названию
            self.sortByName()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        actionSheet.addAction(sortByPriceAction)
        actionSheet.addAction(sortByRatingAction)
        actionSheet.addAction(sortByNameAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func deleteNFT() {
        blurView.removeFromSuperview()
        deleteText.removeFromSuperview()
        deleteButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
        
        guard let indexDelete = indexDelete else { return }
        addedNFTs.remove(at: indexDelete)
        
        reloadViewAfterDelete()

        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func cancelDeletion() {
        blurView.removeFromSuperview()
        deleteText.removeFromSuperview()
        deleteButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
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
        cell.indexCell = indexPath.row
        cell.delegate = self
        return cell
    }
}

// Реализация UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140 
    }
}

extension CartViewController: CartCellDelegate {
    
    func showDeleteView(index: Int) {
        blurView.isHidden = false
        deleteText.isHidden = false
        deleteButton.isHidden = false
        cancelButton.isHidden = false
        iconDeleteImageView.isHidden = false
        
        iconDeleteImageView.image = addedNFTs[index].picture
        indexDelete = index
        
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        
        blurView.isUserInteractionEnabled = true

        view.addSubview(blurView)
        blurView.contentView.addSubview(iconDeleteImageView)
        blurView.contentView.addSubview(deleteText)
        blurView.contentView.addSubview(deleteButton)
        blurView.contentView.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            iconDeleteImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconDeleteImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            iconDeleteImageView.widthAnchor.constraint(equalToConstant: 108),
            iconDeleteImageView.heightAnchor.constraint(equalToConstant: 108),
            
            deleteText.topAnchor.constraint(equalTo: iconDeleteImageView.bottomAnchor, constant: 12),
            deleteText.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
            deleteText.widthAnchor.constraint(equalToConstant: 180),
            deleteText.heightAnchor.constraint(equalToConstant: 36),
            
            deleteButton.topAnchor.constraint(equalTo: deleteText.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 56),
            deleteButton.trailingAnchor.constraint(equalTo: blurView.contentView.centerXAnchor, constant: -4),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.topAnchor.constraint(equalTo: deleteButton.topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: blurView.contentView.centerXAnchor, constant: 4),
            cancelButton.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -57),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
}
