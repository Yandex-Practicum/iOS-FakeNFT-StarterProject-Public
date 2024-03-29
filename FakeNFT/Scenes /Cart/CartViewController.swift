//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 22.03.2024.
//

import UIKit

class CartViewController: UIViewController {
    
    var mockData: [String] = ["NFT1", "NFT2", "NFT3", "NFT4", "NFT5", "NFT6"]
    
    private let emptyCart: UILabel = {
       let label = UILabel()
        label.text = "Корзина пуста"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.widthAnchor.constraint(equalToConstant: 343).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CartCustomCell.self, forCellReuseIdentifier: "customCell")
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //Отделение с кнопкой оплаты
    private let bottomView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "ypLightGray")
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        view.heightAnchor.constraint(equalToConstant: 76).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nftCount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "3 NFT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nftPrice: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "5,34 ETH"
        label.textColor = UIColor(named: "ypUniGreen")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonPay: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 240).isActive = true
        button.addTarget(self, action: #selector(payButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(image: UIImage(named: "filterIcon")!, style: .plain, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
        tableView.delegate = self
        tableView.dataSource = self
        mockData.isEmpty ? setupEmptyViews() : setupAllViews()
        print("Sprint19_Cart1/3")
    }
    
    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        // Добавляем действия для каждой опции сортировки
        alertController.addAction(UIAlertAction(title: "По цене", style: .default) { _ in
            // Обработка сортировки по имени
            print("Сортировка по цене")
        })
    
        alertController.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
            // Обработка сортировки по цене
            print("Сортировка по рейтингу")
        })
        
        alertController.addAction(UIAlertAction(title: "По названию", style: .default) { _ in
            print("Сортировка по названию")})
        
        alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        
        // Показываем UIAlertController
        present(alertController, animated: true, completion: nil)
    }
        
    @objc func payButtonClicked() {
        let viewController = UINavigationController(rootViewController:  PayNftViewController())
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated:  true)
        print("Оплатить!")
    }
    
    private func viewDeleteController() {
        applyBlurEffect()
        let vc = DeleteViewController()
        present(vc, animated: true)
    }
    
    //применяем блюр
    private func applyBlurEffect() {
        guard let window = UIApplication.shared.windows.first else { return }
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window.bounds
        window.addSubview(blurEffectView)
    }
    
    // Находим размытое представление и удаляем его
    func removeBlurEffect() {
        guard let window = UIApplication.shared.windows.first else { return }
        for subview in window.subviews {
            if let blurView = subview as? UIVisualEffectView {
                blurView.removeFromSuperview()
            }
        }
    }
    
    private func setupEmptyViews() {
        view.addSubview(emptyCart)
        NSLayoutConstraint.activate([
            emptyCart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCart.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    
    private func setupAllViews() {
        view.addSubview(tableView)
        
        view.addSubview(bottomView)
        bottomView.addSubview(nftCount)
        bottomView.addSubview(nftPrice)
        bottomView.addSubview(buttonPay)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
        
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            nftCount.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            nftCount.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            
            nftPrice.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            nftPrice.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            
            buttonPay.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            buttonPay.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
        
        ])
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CartCustomCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.nftName.text = mockData[indexPath.row]
        return cell
    }
}

extension CartViewController: CartCellDelegate {
    func deleteButtonTapped(at indexPath: IndexPath) {
        print(indexPath)
        viewDeleteController()
    }
}

