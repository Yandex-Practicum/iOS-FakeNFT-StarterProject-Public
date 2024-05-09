//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 05.05.2024.
//

import Foundation
import UIKit


final class CartViewController: UIViewController, CartViewControllerProtocol {
    
    
 private var presenter: CartPresenterProtocol?
  
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "sort")
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyOrderCell.self, forCellReuseIdentifier: MyOrderCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var imagePay: UIView = {
        let imagePay = UIView()
        imagePay.backgroundColor = UIColor(named: "LightGray")
        imagePay.translatesAutoresizingMaskIntoConstraints = false
        imagePay.layer.masksToBounds = true
        imagePay.layer.cornerRadius = 12
        imagePay.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner ]
        return imagePay
    }()
    
    
    private lazy var amountLabel: UILabel = {
        let amountLabel = UILabel()
        amountLabel.text = "3 NFT"
        amountLabel.font = .caption1
        amountLabel.textColor = UIColor(named: "Black")
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        return amountLabel
    }()
    
    private lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.text = "5,34 ETH"
        moneyLabel.font = .bodyBold
        moneyLabel.textColor = UIColor(named: "Green")
        moneyLabel.translatesAutoresizingMaskIntoConstraints = false
        return moneyLabel
    }()
    
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.backgroundColor =  UIColor(named: "Black")
        button.setTitle("К оплате", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .bodyBold
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.font = .bodyBold
        label.textColor = UIColor(named: "Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var loaderView = LoaderView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "White")
        
        presenter = CartPresenter(viewController: self)
        
        addSubviews()
        setupLayoutImagePay()
        setupLayout()
        tableView.dataSource = self
        tableView.delegate = self
        setupNavigationBar()
        
        showEmptyCart()
    }
    
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(imagePay)
        imagePay.addSubview(amountLabel)
        imagePay.addSubview(moneyLabel)
        imagePay.addSubview(payButton)
        view.addSubview(emptyCartLabel)
    //    view.addSubview(sortButton)
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
            
        }
        let rightButton = UIBarButtonItem(image: UIImage(named: "sort"), style: .plain, target: self, action: #selector(didTapSortButton))
        rightButton.tintColor = UIColor(named: "Black")
        navigationBar.topItem?.setRightBarButton(rightButton, animated: false)
    }
        
    private func setupLayoutImagePay() {
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: imagePay.leadingAnchor, constant: 16),
            amountLabel.topAnchor.constraint(equalTo: imagePay.topAnchor, constant: 16),
            
            moneyLabel.leadingAnchor.constraint(equalTo: imagePay.leadingAnchor, constant: 16),
            moneyLabel.bottomAnchor.constraint(equalTo: imagePay.bottomAnchor, constant: -16),

            payButton.trailingAnchor.constraint(equalTo: imagePay.trailingAnchor, constant: -16),
            payButton.centerYAnchor.constraint(equalTo: imagePay.centerYAnchor),
            payButton.widthAnchor.constraint(equalToConstant: 240),
            payButton.heightAnchor.constraint(equalToConstant: 44),
            
            emptyCartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imagePay.topAnchor.constraint(equalTo:tableView.bottomAnchor),
            imagePay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagePay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagePay.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -83),
            imagePay.heightAnchor.constraint(equalToConstant: 76),
        ])
    }
    
    func showEmptyCart() {
        if presenter?.count() == 0 {
            emptyCartLabel.isHidden = false
            imagePay.isHidden = true
        } else {
            setupNavigationBar()
            guard let count = presenter?.count() else { return }
            guard let totalPrice = presenter?.totalPrice() else { return }
            amountLabel.text = "\(count) NFT"
            moneyLabel.text = "\(totalPrice) ETH"
            emptyCartLabel.isHidden = true
            imagePay.isHidden = false
            tableView.reloadData()
        }
    }
    
    func updateCartTable() {
        tableView.reloadData()
    }
    
    func startLoadIndicator() {
        loaderView.showLoading()
    }
    
    func stopLoadIndicator() {
        loaderView.hideLoading()
    }
    
    @objc private func didTapSortButton() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "По цене", style: .default, handler: { [weak self] (UIAlertAction) in
            guard self != nil else { return }
            //TODO: реализовать сортировку
        } ))
        
        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default, handler: { [weak self] (UIAlertAction) in
            guard self != nil else { return }
            //TODO: реализовать сортировку
        } ))
        
        alert.addAction(UIAlertAction(title: "По названию", style: .default, handler: { [weak self] (UIAlertAction) in
            guard self != nil else { return }
            //TODO: реализовать сортировку
        } ))
        
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: { (UIAlertAction) in
        } ))
        
        self.present(alert, animated: true)
    }
    
    @objc private func didTapPayButton() {
        let payController = PayViewController()
        payController.hidesBottomBarWhenPushed = true
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(payController, animated: true)
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = presenter?.count() else {return 0}
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyOrderCell.identifier, for: indexPath) as? MyOrderCell else { return UITableViewCell() }
                guard let model = presenter?.getModel(indexPath: indexPath) else { return cell }
                cell.delegate = self
                cell.updateCell(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func didTapDeleteButton(id: String, image: UIImage) {
//        let deleteViewController = CartDeleteViewController(nftImage: image, idForDelete: id)
//        deleteViewController.modalPresentationStyle = .overCurrentContext
//        self.tabBarController?.present(deleteViewController, animated: true)
    }
}



  



