//
//  CartMainViewController.swift
//  FakeNFT
//
//  Created by Кирилл Дробин on 15.03.2025.
//

import UIKit

final class CartMainViewController: UIViewController {
    // MARK: - Singletone
    private let storage = Storage.shared
    private let paymentNetworkService = PaymentNetworkService.shared
    
    // MARK: - Private Properties
    private var cartMainViewControllerObserver: NSObjectProtocol?
    
    // MARK: - UI Elements
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = NSLocalizedString("Корзина пуста", comment: "")
        placeholderLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return placeholderLabel
    }()
    
    private lazy var sortImage: UIImage = {
        let sortImage = UIImage(named: "Vector")
        return sortImage ?? UIImage()
    }()
    
    private lazy var nftListTableView: UITableView = {
        let list = UITableView()
        list.separatorStyle = .none
        list.backgroundColor = .clear
        list.allowsSelection = false
        return list
    }()
    
    private lazy var payFieldView: UIView = {
        let payView = UIView()
        payView.backgroundColor = UIColor(named: "greyForDarkMode")
        payView.layer.cornerRadius = 12
        payView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return payView
    }()
    
    private lazy var selectedNftCountLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return countLabel
    }()
    
    private lazy var priceNftLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.textColor = UIColor(red: 28/255, green: 159/255, blue: 0/255, alpha: 1)
        priceLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return priceLabel
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "blackForDarkMode")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(UIColor(named: "whiteForDarkMode"), for: .normal)
        button.setTitle(NSLocalizedString("К оплате", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(switchToPayScreen), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteForDarkMode")
        navControllerSetup()
        addSubviews()
        makeConstraints()
        nftListTableView.dataSource = self
        nftListTableView.delegate = self
        nftListTableView.register(NftCellView.self, forCellReuseIdentifier: "cell")
        storage.mockCartNfts = storage.data // удалить после 3его эпика
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        cartMainScreenSetup()
        labelsSetup()
        
        self.cartMainViewControllerObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name("delete"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.switchDeleteNftViewController()
        }
        
        self.cartMainViewControllerObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name("tabBar"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTable()
            self.cartMainScreenSetup()
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    // MARK: - Private Methods
    private func navControllerSetup() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: sortImage, style: .plain, target: self, action: #selector(cartSortALert))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "blackForDarkMode")
    }
    
    private func cartMainScreenSetup() {
        if storage.mockCartNfts.isEmpty {
            nftListTableView.isHidden = true
            payFieldView.isHidden = true
            selectedNftCountLabel.isHidden = true
            priceNftLabel.isHidden = true
            payButton.isHidden = true
            navigationController?.navigationBar.isHidden = true
            
            placeholderLabel.isHidden = false
        } else {
            nftListTableView.isHidden = false
            payFieldView.isHidden = false
            selectedNftCountLabel.isHidden = false
            priceNftLabel.isHidden = false
            payButton.isHidden = false
            navigationController?.navigationBar.isHidden = false
            
            placeholderLabel.isHidden = true
        }
    }
    
    private func labelsSetup() {
        selectedNftCountLabel.text = "\(storage.mockCartNfts.count) NFT"
        
        var sumPrice = Float()
        for i in storage.mockCartNfts {
            sumPrice += i.price
        }
        priceNftLabel.text = "\(NSString(format: "%.2f", sumPrice)) ETH"
    }
    
    private func ratingSetup(ratingInt: Int) -> String {
        return String(repeating: "★", count: ratingInt)
    }
    
    private func updateTable() {
        DispatchQueue.main.async { [weak self] in
            self?.nftListTableView.reloadData()
            self?.labelsSetup()
        }
    }
    
    private func addSubviews() {
        [
            placeholderLabel,
            nftListTableView,
            payFieldView,
            selectedNftCountLabel,
            priceNftLabel,
            payButton,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            nftListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            nftListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            nftListTableView.bottomAnchor.constraint(equalTo: payFieldView.topAnchor, constant: 0),
            
            payFieldView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            payFieldView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            payFieldView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            payFieldView.heightAnchor.constraint(equalToConstant: 76),
            
            payButton.topAnchor.constraint(equalTo: payFieldView.topAnchor, constant: 16),
            payButton.leadingAnchor.constraint(equalTo: payFieldView.leadingAnchor, constant: 119),
            payButton.trailingAnchor.constraint(equalTo: payFieldView.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: payFieldView.bottomAnchor, constant: -16),
            
            selectedNftCountLabel.topAnchor.constraint(equalTo: payFieldView.topAnchor, constant: 16),
            selectedNftCountLabel.leadingAnchor.constraint(equalTo: payFieldView.leadingAnchor, constant: 16),
            selectedNftCountLabel.trailingAnchor.constraint(equalTo: payFieldView.trailingAnchor, constant: -317),
            selectedNftCountLabel.bottomAnchor.constraint(equalTo: payFieldView.bottomAnchor, constant: -40),
            
            priceNftLabel.topAnchor.constraint(equalTo: payFieldView.topAnchor, constant: 38),
            priceNftLabel.leadingAnchor.constraint(equalTo: payFieldView.leadingAnchor, constant: 16),
            priceNftLabel.trailingAnchor.constraint(equalTo: payFieldView.trailingAnchor, constant: -280),
            priceNftLabel.bottomAnchor.constraint(equalTo: payFieldView.bottomAnchor, constant: -16),
        ])
    }
    
    @objc private func switchToPayScreen() {
        let payViewController = PayViewController()
        self.navigationController?.pushViewController(payViewController, animated: true)
    }
    
    @objc private func cartSortALert() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        present(alert, animated: true)
        
        alert.addAction(UIAlertAction(title: "По цене", style: .default, handler: { action in
            self.storage.mockCartNfts.sort(by: {$0.price > $1.price})
            DispatchQueue.main.async {
                self.updateTable()
            }
            alert.dismiss(animated: false)
        }))
        
        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default, handler: { action in
            self.storage.mockCartNfts.sort(by: {$0.rating > $1.rating})
            DispatchQueue.main.async {
                self.updateTable()
            }
            alert.dismiss(animated: false)
        }))
        
        alert.addAction(UIAlertAction(title: "По названию", style: .default, handler: { action in
            self.storage.mockCartNfts.sort(by: {$0.name > $1.name})
            DispatchQueue.main.async {
                self.updateTable()
            }
            alert.dismiss(animated: false)
        }))
        
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: { action in
            alert.dismiss(animated: false)
        }))
        
    }
    
    func switchDeleteNftViewController() {
        let backView = view.snapshotView(afterScreenUpdates: false) ?? UIView()
        let deleteNftViewController = DeleteNftViewController()
        deleteNftViewController.modalPresentationStyle = .overCurrentContext
        deleteNftViewController.modalTransitionStyle = .crossDissolve
        deleteNftViewController.configureView(mainView: backView)
        present(deleteNftViewController, animated: true)
        
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.isHidden = true
        }
    }
}

extension CartMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { storage.mockCartNfts.count }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 140 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NftCellView else { return NftCellView()}
        
        cell.cellSetup(nftImageUrl: URL(string: storage.mockCartNfts[indexPath.row].images.first ?? "no url") ?? URL(fileURLWithPath: "no url"),
                       nftNameLabel: storage.mockCartNfts[indexPath.row].name,
                       priceValueLabel: "\(storage.mockCartNfts[indexPath.row].price) ETH", nftIndex: indexPath.row,
                       rating: ratingSetup(ratingInt: storage.mockCartNfts[indexPath.row].rating))
        
        return cell
    }
}
