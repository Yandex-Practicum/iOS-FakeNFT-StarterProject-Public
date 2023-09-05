import UIKit

protocol CartCellDelegate: AnyObject {
    func didTapDeleteButton(at index: Int)
}

final class CartViewController: UIViewController {
    private var indexCell: Int?
    let viewModel: CartViewModel
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Sort"), for: .normal)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemBackground
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let purchaseView: CartView = {
        let view = CartView()
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deleteView: DeleteView = {
        let view = DeleteView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Bold.size17
        label.backgroundColor = UIColor.systemBackground
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.text = "Корзина пуста"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cartTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    // MARK: DeleteView
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewDidLoad { [weak self] in
            self?.setupView()
            self?.configureTableView()
            self?.cartTableView.reloadData()
            self?.updatePurchaseView()
        }
    }
    private func configureSorting() {
        let alertSheet = UIAlertController(title: nil, message: "Сортировка", preferredStyle: .actionSheet)
        let sortByPrice = UIAlertAction(title: "По цене", style: .default) { _ in
            self.viewModel.didSortByPrice()
            self.cartTableView.reloadData()
        }
        let sortByRating = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.viewModel.didSortByRating()
            self.cartTableView.reloadData()
        }
        let sortByName = UIAlertAction(title: "По имени", style: .default) { _ in
            self.viewModel.didSortByName()
            self.cartTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        alertSheet.addAction(sortByPrice)
        alertSheet.addAction(sortByRating)
        alertSheet.addAction(sortByName)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true)
    }
    
    @objc func sortButtonTapped() {
        configureSorting()
    }
    
    private func removeDeleteView() {
        deleteView.removeDeleteView()
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureTableView() {
        cartTableView.delegate = self
        cartTableView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.$cartModels.bind { [weak self] _ in
            self?.cartTableView.reloadData()
        }
        viewModel.$isTableViewHidden.bind { [weak self] isHidden in
            self?.cartTableView.isHidden = isHidden
        }
        viewModel.$isPlaceholderHidden.bind { [weak self] isHidden in
            self?.placeholderLabel.isHidden = isHidden
        }
        viewModel.bindCart()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        if viewModel.cartModels.isEmpty {
            setupEmptyView()
        } else {
            setupFilledView()
        }
    }
    
   private func updatePurchaseView() {
        let cartCount = viewModel.cartModels.count
        purchaseView.setNftCount(text: "\(cartCount) NFT")
        let sum = viewModel.cartModels.reduce(0.0) { (result, nft) in
            return result + nft.price
        }
        let formattedPrice = String(format: "%.2f", sum)
        purchaseView.setSumNft(text: "\(formattedPrice) ETH")
    }
    private func setupFilledView() {
        configureTableView()
        purchaseView.delegate = self
        view.addSubview(cartTableView)
        view.addSubview(purchaseView)
        view.addSubview(deleteView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
        NSLayoutConstraint.activate([
            purchaseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -83),
            purchaseView.heightAnchor.constraint(equalToConstant: 78),
            purchaseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            purchaseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cartTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cartTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cartTableView.bottomAnchor.constraint(equalTo: purchaseView.topAnchor),
            deleteView.topAnchor.constraint(equalTo: view.topAnchor),
            deleteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deleteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func setupEmptyView() {
        view.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.identifier,
            for: indexPath) as? CartTableViewCell
        else { assertionFailure("Unable to dequeue CartTableViewCell")
            return UITableViewCell()
        }
        let nft = viewModel.cartModels[indexPath.row]
        cell.delegate = self
        cell.indexCell = indexPath.row
        cell.configureCell(with: nft)
        return cell
    }
}

extension CartViewController: CartViewDelegate {
    func didTapPurchaseButton() {
        let purchaseVC = CartPurchaseViewController()
        purchaseVC.hidesBottomBarWhenPushed = true
        let navigationController = UINavigationController(rootViewController: purchaseVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}
extension CartViewController: CartCellDelegate {
    func didTapDeleteButton(at index: Int) {
        deleteView.isHidden = false
        deleteView.backgroundColor = .clear
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        indexCell = index
        deleteView.showDeleteView(atIndex: indexCell ?? 0)
        
        deleteView.onCancelButtonTapped = { [weak self] in
            self?.removeDeleteView()
            self?.deleteView.isHidden = true
        }
        deleteView.onDeleteButtonTapped = { [weak self] in
            self?.viewModel.didDeleteNFT(at: index)
            self?.cartTableView.reloadData()
            self?.removeDeleteView()
            self?.deleteView.isHidden = true
        }
    }
}
