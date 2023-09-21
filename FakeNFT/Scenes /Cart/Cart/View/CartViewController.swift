import UIKit
import ProgressHUD

final class CartViewController: UIViewController {
    
    enum Route: String {
        case pay
        case paymentChoice
        case purchasResult
    }
    
    private let viewModel: CartViewModelProtocol
    var model: NFTModel?
    private var indexDelete: Int?
    var router: CartRouter
    
    init(viewModel: CartViewModelProtocol = CartViewModel(), router: CartRouter = DefaultCartRouter()) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addViews()
        setupAllView()
        viewModel.observe()
        bind()
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var plugLabel: UILabel = {
        let plugLabel = UILabel()
        plugLabel.isHidden = true
        plugLabel.text = "Корзина пуста"
        plugLabel.font = .bodyBold
        plugLabel.textColor = .ypBlack
        return plugLabel
    }()
 
    private lazy var sortButton: UIButton = {
        let sortButton = UIButton()
        sortButton.setImage(UIImage(named: "sortButton"), for: .normal)
        sortButton.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        return sortButton
    }()
    
    private lazy var buttonPaymentView: UIView = {
        let buttonPaymentView = UIView()
        buttonPaymentView.backgroundColor = .ypLightGrey
        buttonPaymentView.layer.cornerRadius = 12
        buttonPaymentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return buttonPaymentView
    }()
    
    private lazy var countNFTLabel: UILabel = {
        let countNFTLabel = UILabel()
        countNFTLabel.text = "0 NFT"
        
        return countNFTLabel
    }()
    
    private lazy var totalCoastNFTLabel: UILabel = {
        let totalCoastNFTLabel = UILabel()
        totalCoastNFTLabel.text = "0,0"
        totalCoastNFTLabel.textColor = .ypGreen
        totalCoastNFTLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return totalCoastNFTLabel
    }()
    
    private lazy var payButton: UIButton = {
        let payButton = UIButton()
        payButton.setTitle("К оплате", for: .normal)
        payButton.titleLabel?.font = .bodyBold
        payButton.setTitleColor(.ypWhite, for: .normal)
        payButton.backgroundColor = .ypBlack
        payButton.layer.cornerRadius = 16
        payButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        return payButton
    }()
    
    private lazy var deleteView: UIVisualEffectView = {
        let deleteView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        deleteView.frame = self.view.bounds
        deleteView.isHidden = true
        return deleteView
    }()
    
    private lazy var deletingImage: UIImageView = {
        let deletingImage = UIImageView()
        deletingImage.image = UIImage(named: "mockImageNft")
        deletingImage.layer.cornerRadius = 16
        deletingImage.layer.masksToBounds = true
        deletingImage.isHidden = true
        return deletingImage
    }()
    
    private lazy var deleteLabel: UILabel = {
        let deleteLabel = UILabel()
        deleteLabel.text = "Вы уверены, что хотите удалить объект из корзины?"
        deleteLabel.font = .caption2
        deleteLabel.textAlignment = .center
        deleteLabel.numberOfLines = 0
        deleteLabel.isHidden = true
        return deleteLabel
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.ypRed, for: .normal)
        deleteButton.backgroundColor = .ypBlack
        deleteButton.layer.cornerRadius = 12
        deleteButton.isHidden = true
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return deleteButton
        
    }()
    
    private lazy var returnButton: UIButton = {
        let returnButton = UIButton()
        returnButton.setTitle("Вернуться", for: .normal)
        returnButton.setTitleColor(.ypWhite, for: .normal)
        returnButton.backgroundColor = .ypBlack
        returnButton.layer.cornerRadius = 12
        returnButton.isHidden = true
        returnButton.addTarget(self, action: #selector(didTapReturnButton), for: .touchUpInside)
        return returnButton
    }()
    
    private func addViews(){
        [tableView, sortButton, buttonPaymentView, countNFTLabel, totalCoastNFTLabel, payButton, plugLabel].forEach(view.setupView(_:))
    }
    
    private func setNavBar() {
        if let navigationBar = navigationController?.navigationBar {
            let sortButton = UIBarButtonItem(customView: sortButton)
            self.navigationItem.rightBarButtonItem = sortButton
            NSLayoutConstraint.activate([
                self.sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
                self.sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            ])
            navigationBar.topItem?.setRightBarButton(sortButton, animated: false)
        }
    }
    
    private func setupEmptyLabel() {
        view.setupView(plugLabel)
        NSLayoutConstraint.activate([
            plugLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupButtonPaymentView(){
        view.addSubview(buttonPaymentView)
        buttonPaymentView.addSubview(countNFTLabel)
        buttonPaymentView.addSubview(totalCoastNFTLabel)
        buttonPaymentView.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            buttonPaymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -83),
            buttonPaymentView.heightAnchor.constraint(equalToConstant: 76),
            buttonPaymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonPaymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countNFTLabel.leadingAnchor.constraint(equalTo: buttonPaymentView.leadingAnchor, constant: 16),
            countNFTLabel.topAnchor.constraint(equalTo: buttonPaymentView.topAnchor, constant: 16),
            totalCoastNFTLabel.topAnchor.constraint(equalTo: countNFTLabel.bottomAnchor, constant: 1),
            totalCoastNFTLabel.leadingAnchor.constraint(equalTo: buttonPaymentView.leadingAnchor, constant: 16),
            payButton.topAnchor.constraint(equalTo: buttonPaymentView.topAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: buttonPaymentView.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: buttonPaymentView.bottomAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    private func setupTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    private func setupAllView() {
        setupEmptyLabel()
        setNavBar()
        setupTableView()
        setupButtonPaymentView()
    }
    
    private func bind() {
        viewModel.nftsObservable.bind { [weak self] _ in
            guard let self else { return }
            UIView.animate(withDuration: 0.3) {
                self.configureView(model: self.viewModel.nftInfo)
            }
            self.tableView.reloadData()
        }
        
        viewModel.isLoadingObservable.bind { [weak self] isLoading in
            guard let self else { return }
            if isLoading {
                UIBlockingProgressHUD.show()
            } else {
                UIBlockingProgressHUD.dismiss()
                self.tableView.reloadData()
            }
        }
        
        viewModel.isCartEmptyObservable.bind { [weak self] isEmptyCart in
            guard let self else { return }
            if isEmptyCart {
                self.showEmptyCart()
            } else {
                self.showCart()
            }
        }
    }
    
    private func showEmptyCart() {
        plugLabel.isHidden = false
        navigationController?.isNavigationBarHidden = true
        tableView.isHidden = true
        buttonPaymentView.isHidden = true
        payButton.isHidden = true
        countNFTLabel.isHidden = true
        totalCoastNFTLabel.isHidden = true
    }
    
    private func showCart() {
        plugLabel.isHidden = true
        navigationController?.isNavigationBarHidden = false
        tableView.isHidden = false
        buttonPaymentView.isHidden = false
        payButton.isHidden = false
        countNFTLabel.isHidden = false
        totalCoastNFTLabel.isHidden = false
    }
    
    private func configureView(model: NFTInfo) {
        if let formattedPrice = viewModel.formattedPrice.string(from: NSNumber(value: model.price)) {
            totalCoastNFTLabel.text = "\(formattedPrice) ETH"
        }
        countNFTLabel.text = "\(model.count) NFT"
    }
    
    @objc private func didTapPayButton() {
        router.perform(.pay, from: self)
    }
    
    @objc private func didTapReturnButton() {
        deleteView.removeFromSuperview()
        deleteLabel.removeFromSuperview()
        deleteButton.removeFromSuperview()
        returnButton.removeFromSuperview()
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func didTapDeleteButton() {
        deleteView.removeFromSuperview()
        deleteLabel.removeFromSuperview()
        deleteButton.removeFromSuperview()
        returnButton.removeFromSuperview()
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
        guard let indexDelete = indexDelete else { return }
        viewModel.didDeleteNFT(index: indexDelete)
        if viewModel.nfts.isEmpty {
            showEmptyCart()
        }
    }
    
    @objc private func didTapSortButton() {
        let action = UIAlertController(title: nil, message: "Сортировка", preferredStyle: .actionSheet)
        let sortByPrice = UIAlertAction(title: "По цене", style: .default) { _ in
            self.viewModel.sortByPrice()
        }
        let sortByRating = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.viewModel.sortByRating()
        }
        let sortByName = UIAlertAction(title: "По названию", style: .default) { _ in
            self.viewModel.sortByName()
        }
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel)
        action.addAction(sortByPrice)
        action.addAction(sortByRating)
        action.addAction(sortByName)
        action.addAction(cancel)
        present(action, animated: true)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.identifier, for: indexPath) as? CartCell else {
            return UITableViewCell()
        }
        let model = viewModel.nfts[indexPath.row]
        cell.configureCell(model: model)
        cell.indexCell = indexPath.row
        cell.delegate = self
        return cell
    }
}

extension CartViewController: CartCellDelegate {
    func showDeleteView(index: Int) {
        indexDelete = index
        deleteView.isHidden = false
        deleteLabel.isHidden = false
        deleteButton.isHidden = false
        deletingImage.isHidden = false
        returnButton.isHidden = false
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        deleteView.isUserInteractionEnabled = true
        
        deletingImage.kf.setImage(with: viewModel.nfts[index].images.first)
        
        view.setupView(deleteView)
        deleteView.contentView.setupView(deleteLabel)
        deleteView.contentView.setupView(deleteButton)
        deleteView.contentView.setupView(deletingImage)
        deleteView.contentView.setupView(returnButton)
        
        NSLayoutConstraint.activate([
            deleteView.topAnchor.constraint(equalTo: view.topAnchor),
            deleteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deleteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            deletingImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deletingImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            deletingImage.widthAnchor.constraint(equalToConstant: 108),
            deletingImage.heightAnchor.constraint(equalToConstant: 108),
            deleteLabel.topAnchor.constraint(equalTo: deletingImage.bottomAnchor, constant: 12),
            deleteLabel.centerXAnchor.constraint(equalTo: deletingImage.centerXAnchor),
            deleteLabel.widthAnchor.constraint(equalToConstant: 180),
            deleteLabel.heightAnchor.constraint(equalToConstant: 36),
            deleteButton.topAnchor.constraint(equalTo: deleteLabel.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: deleteView.leadingAnchor, constant: 56),
            deleteButton.trailingAnchor.constraint(equalTo: deleteView.centerXAnchor, constant: -4),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            returnButton.topAnchor.constraint(equalTo: deleteLabel.bottomAnchor, constant: 20),
            returnButton.trailingAnchor.constraint(equalTo: deleteView.trailingAnchor, constant: -56),
            returnButton.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: 4),
            returnButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
