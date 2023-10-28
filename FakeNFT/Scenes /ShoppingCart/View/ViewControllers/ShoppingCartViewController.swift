import UIKit

final class ShoppingCartViewController: UIViewController {
    
    private let viewModel: ShoppingCartViewModel
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
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
        label.text = "0 NFT"
        label.font = .caption1
        label.textColor = .textOnSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        let formattedPrice = String(format: "%.2f", 0.0)
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
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .bodyBold
        button.addTarget(self, action: #selector(toPaymentMethod), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private var indexDelete: Int?
    
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
        label.text = "Вы уверены, что хотите \n удалить объект из корзины?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.addTarget(nil, action: #selector(deleteNFT), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(nil, action: #selector(cancelDeletion), for: .touchUpInside)
        button.setTitle("Вернуться", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
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
    
    
    init(viewModel: ShoppingCartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.$NFTModels.bind(executeInitially: true) { [weak self] nfts in
            self?.tableView.reloadData()
            self?.setupView()
            self?.nftCountLabel.text = "\(nfts.count)" + " NFT"
            var totalPrice: Float = 0
            for nft in nfts {
                totalPrice += nft.price
            }
            let formattedPrice = String(format: "%.2f", totalPrice)
            self?.totalPriceLabel.text = formattedPrice + " ETH"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        
        viewModel.viewDidLoad()
    }
    
    private func setupView() {
        if viewModel.NFTModels.isEmpty {
            setupEmptyView()
            hiddenCorrection()
        } else {
            setupNavBar()
            setupTableView()
            setupPaymentView()
            hiddenCorrection()
            setupLoader()
        }
    }
    
    private func setupNavBar() {
        if let navBar = navigationController?.navigationBar {
            let sortButton = UIButton(type: .custom)
            sortButton.setImage(UIImage(named: "sortButton"), for: .normal)
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
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isUserInteractionEnabled = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    private func setupPaymentView() {
        view.addSubview(paymentView)
        paymentView.addSubview(nftCountLabel)
        paymentView.addSubview(totalPriceLabel)
        paymentView.addSubview(paymentButton)
        
        NSLayoutConstraint.activate([
            paymentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentView.heightAnchor.constraint(equalToConstant: 76),
            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nftCountLabel.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
            nftCountLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            nftCountLabel.widthAnchor.constraint(equalToConstant: 79),
            nftCountLabel.heightAnchor.constraint(equalToConstant: 20),
            
            totalPriceLabel.topAnchor.constraint(equalTo: nftCountLabel.bottomAnchor, constant: 2),
            totalPriceLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            totalPriceLabel.widthAnchor.constraint(equalToConstant: 90),
            totalPriceLabel.heightAnchor.constraint(equalToConstant: 22),
            
            paymentButton.centerYAnchor.constraint(equalTo: paymentView.centerYAnchor),
            paymentButton.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 44),
            paymentButton.widthAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    private func setupLoader() {
        view.addSubview(activityIndicator)
        activityIndicator.layer.zPosition = 99
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func countPrice(_ nftArray: [NFT]) -> Float {
        var totalPrice: Float = 0
        for nft in nftArray {
            totalPrice += nft.price
        }
        return totalPrice
    }
    
    private func hiddenCorrection() {
        if viewModel.NFTModels.isEmpty {
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
    
    func setLoaderIsHidden(_ isHidden: Bool) {
        if isHidden {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
    
    @objc private func showSortingOptions() {
        
        let actionSheet = UIAlertController(
            title: nil, message: "Сортировка", preferredStyle: .actionSheet)
        
        let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { _ in
            self.viewModel.sortByPrice()
        }
        
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.viewModel.sortByRating()
        }
        
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { _ in
            self.viewModel.sortByName()
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
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        
        guard let indexDelete = indexDelete else { return }
        viewModel.didDeleteNFT(index: indexDelete)
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

extension ShoppingCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.NFTModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTCell.reuseIdentifier, for: indexPath) as? NFTCell else {
            return UITableViewCell()
        }
        
        let nft = viewModel.NFTModels[indexPath.row]
        
        cell.backgroundColor = .background
        cell.selectionStyle = .none
        cell.configure(with: nft)
        cell.indexCell = indexPath.row
        cell.delegate = self
        return cell
    }
}

extension ShoppingCartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension ShoppingCartViewController: CartCellDelegate {
    
    func showDeleteView(index: Int) {
        blurView.isHidden = false
        deleteText.isHidden = false
        deleteButton.isHidden = false
        cancelButton.isHidden = false
        iconDeleteImageView.isHidden = false
        
        iconDeleteImageView.kf.setImage(with: viewModel.NFTModels[index].images.first)
        iconDeleteImageView.layer.cornerRadius = 12
                iconDeleteImageView.layer.masksToBounds = true
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
            deleteText.widthAnchor.constraint(equalToConstant: 220),
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
